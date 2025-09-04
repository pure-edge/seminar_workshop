import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/character_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Box<CharacterModel> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<CharacterModel>('characters');
  }

  // Create OR Update (if existing provided)
  Future<void> _openCharacterDialog({CharacterModel? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final classCtrl = TextEditingController(text: existing?.heroClass ?? '');
    final powerCtrl = TextEditingController(
      text: (existing?.power ?? 50).toString(),
    );

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add Character' : 'Edit Character'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: classCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Class (e.g., Warrior, Mage)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: powerCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Power (0-100)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // cancel
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final heroClass = classCtrl.text.trim();
                final power = int.tryParse(powerCtrl.text.trim()) ?? 0;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name cannot be empty')),
                  );
                  return;
                }
                if (power < 0 || power > 100) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Power must be 0–100')),
                  );
                  return;
                }

                if (existing == null) {
                  // CREATE
                  final id = DateTime.now().millisecondsSinceEpoch
                      .toString(); // simple unique id
                  final model = CharacterModel(
                    id: id,
                    name: name,
                    heroClass: heroClass.isEmpty ? 'Adventurer' : heroClass,
                    power: power,
                  );
                  _box.put(model.id, model);
                } else {
                  // UPDATE (reuse same id)
                  final updated = CharacterModel(
                    id: existing.id,
                    name: name,
                    heroClass: heroClass.isEmpty ? 'Adventurer' : heroClass,
                    power: power,
                  );
                  _box.put(updated.id, updated);
                }

                Navigator.pop(context); // close dialog
              },
              child: Text(existing == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(CharacterModel character) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Character'),
        content: Text('Delete ${character.name}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await _box.delete(character.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Fantasy Roster')),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, Box<CharacterModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('No characters yet. Tap + to add.'),
            );
          }
          final list = box.values.toList();
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(c.name),
                subtitle: Text('${c.heroClass} · Power: ${c.power}'),
                onTap: () => _openCharacterDialog(existing: c), // EDIT
                trailing: SizedBox(
                  width: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openCharacterDialog(existing: c),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(c),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCharacterDialog(), // CREATE
        child: const Icon(Icons.add),
      ),
    );
  }
}

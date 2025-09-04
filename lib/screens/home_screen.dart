import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/character_model.dart';

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
        final t = Theme.of(context).textTheme;
        return AlertDialog(
          title: Text(
            existing == null ? 'Add Character' : 'Edit Character',
            style: t.titleMedium,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g., Arthas',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: classCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    hintText: 'e.g., Warrior, Mage',
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
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Fantasy Roster')),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(),
        builder: (context, Box<CharacterModel> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group, size: 64, color: scheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'No characters yet',
                      style: t.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap the + button to add your first hero.',
                      style: t.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final list = box.values.toList();
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final c = list[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: scheme.primary.withOpacity(0.12),
                    child: Icon(Icons.person, color: scheme.primary),
                  ),
                  title: Text(c.name, style: t.titleMedium),
                  subtitle: Text(
                    '${c.heroClass} · Power: ${c.power}',
                    style: t.bodyMedium,
                  ),
                  onTap: () => _openCharacterDialog(existing: c), // EDIT
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openCharacterDialog(existing: c),
                      ),
                      IconButton(
                        tooltip: 'Delete',
                        icon: const Icon(Icons.delete),
                        color: Colors.red.shade400,
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

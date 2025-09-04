import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/character_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<CharacterModel> characterBox;

  @override
  void initState() {
    super.initState();
    characterBox = Hive.box<CharacterModel>('characters');
  }

  void _addCharacter() {
    final hero = CharacterModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "Miya",
      heroClass: "Marksman",
      power: 90,
    );
    characterBox.put(hero.id, hero); // save hero in Hive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Fantasy Roster")),
      body: ValueListenableBuilder(
        valueListenable: characterBox.listenable(),
        builder: (context, Box<CharacterModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text("No characters yet."));
          }

          final characters = box.values.toList();
          return ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final char = characters[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(char.name),
                subtitle: Text("${char.heroClass} - Power: ${char.power}"),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCharacter,
        child: const Icon(Icons.add),
      ),
    );
  }
}

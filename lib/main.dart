import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/home_screen.dart';
import 'models/character_model.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();

  // 2. Register adapter
  Hive.registerAdapter(CharacterModelAdapter());

  // 3. Open a box (like a notebook for characters)
  await Hive.openBox<CharacterModel>('characters');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}

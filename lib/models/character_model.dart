import 'package:hive/hive.dart';

part 'character_model.g.dart';

@HiveType(typeId: 1)
class CharacterModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String heroClass;

  @HiveField(3)
  int power;

  CharacterModel({
    required this.id,
    required this.name,
    required this.heroClass,
    required this.power,
  });
}

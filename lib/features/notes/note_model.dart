import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 6)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String color; // Hex string for color

  @HiveField(4)
  double rotation; // For playful UI

  Note({
    required this.id,
    required this.content,
    required this.date,
    required this.color,
    required this.rotation,
  });
}

import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 0)
class FavoriteModel {
  @HiveField(1)
  final String id;

  @HiveField(2)
  final String thumbnail;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String singer;

  @HiveField(5)
  final String duration;

  @HiveField(6)
  final DateTime createdAt;

  FavoriteModel({
    required this.id,
    required this.thumbnail,
    required this.title,
    required this.singer,
    required this.duration,
    required this.createdAt,
  });
}

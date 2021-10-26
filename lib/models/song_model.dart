import 'dart:convert';

import 'package:file_picker/file_picker.dart';

class SongModel {
  SongModel({
    this.id,
    this.song,
    this.songPlatformFile,
    this.thumbnailPlatformFile,
    this.title,
    this.singer,
    this.lyric,
    this.thumbnailUrl,
    this.description,
    this.isError = false,
  });

  String? id;
  Song? song;
  PlatformFile? songPlatformFile;
  PlatformFile? thumbnailPlatformFile;
  String? title;
  String? singer;
  String? lyric;
  String? thumbnailUrl;
  String? description;
  bool isError;

  factory SongModel.fromRawJson(String str) => SongModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        id: json['id'],
        song: json['song'] == null ? null : Song.fromJson(json['song']),
        title: json['title'],
        singer: json['singer'],
        lyric: json['lyric'],
        thumbnailUrl: json['thumbnail_url'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'song': song == null ? null : song!.toJson(),
        'title': title,
        'singer': singer,
        'lyric': lyric,
        'thumbnail_url': thumbnailUrl,
        'description': description,
      };
}

class Song {
  Song({this.name, this.url});

  String? name;
  String? url;

  factory Song.fromRawJson(String str) => Song.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Song.fromJson(Map<String, dynamic> json) => Song(name: json['name'], url: json['url']);

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}

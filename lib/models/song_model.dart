import 'dart:convert';

import 'dart:io';

import 'package:file_picker/file_picker.dart';

class SongModel {
  SongModel({
    this.song,
    this.songPlatformFile,
    this.thumbnailPlatformFile,
    this.title,
    this.singer,
    this.lyric,
    this.thumbnail,
    this.description,
  });

  File? song;
  PlatformFile? songPlatformFile;
  PlatformFile? thumbnailPlatformFile;
  String? title;
  String? singer;
  String? lyric;
  String? thumbnail;
  String? description;

  factory SongModel.fromRawJson(String str) => SongModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        song: json['song'],
        songPlatformFile: json['songPlatformFile'],
        thumbnailPlatformFile: json['thumbnailPlatformFile'],
        title: json['title'],
        singer: json['singer'],
        lyric: json['lyric'],
        thumbnail: json['thumbnail'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'song': song,
        'songPlatformFile': songPlatformFile,
        'thumbnailPlatformFile': thumbnailPlatformFile,
        'title': title,
        'singer': singer,
        'lyric': lyric,
        'thumbnail': thumbnail,
        'description': description,
      };
}

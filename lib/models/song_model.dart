import 'dart:convert';

import 'package:file_picker/file_picker.dart';

// TODO remove nullable parameter ?

class SongModel {
  SongModel({
    this.id,
    this.fileDetail,
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
  FileDetail? fileDetail;
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
        fileDetail: json['song'] == null ? null : FileDetail.fromJson(json['song']),
        title: json['title'],
        singer: json['singer'],
        lyric: json['lyric'],
        thumbnailUrl: json['thumbnail_url'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'song': fileDetail == null ? null : fileDetail!.toJson(),
        'title': title,
        'singer': singer,
        'lyric': lyric,
        'thumbnail_url': thumbnailUrl,
        'description': description,
      };
}

class FileDetail {
  FileDetail({this.name, this.duration, this.url});

  String? name;
  String? duration;
  String? url;

  String toRawJson() => json.encode(toJson());

  factory FileDetail.fromJson(Map<String, dynamic> json) =>
      FileDetail(name: json['name'], duration: json['duration'], url: json['url']);

  Map<String, dynamic> toJson() => {'name': name, 'duration': duration, 'url': url};
}

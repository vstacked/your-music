import 'dart:convert';

import 'package:file_picker/file_picker.dart';

abstract class _BaseModel<T> {
  _BaseModel({
    this.id = '',
    this.fileDetail,
    this.title = '',
    this.singer = '',
    this.lyric = '',
    this.thumbnailUrl = '',
    this.description = '',
  });

  String id;
  FileDetail? fileDetail;
  String title;
  String singer;
  String lyric;
  String thumbnailUrl;
  String description;

  // T fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}

class SongModel extends _BaseModel<SongModel> {
  SongModel({
    String id = '',
    FileDetail? fileDetail,
    String title = '',
    String singer = '',
    String lyric = '',
    String thumbnailUrl = '',
    String description = '',
  }) : super(
          id: id,
          fileDetail: fileDetail,
          title: title,
          singer: singer,
          lyric: lyric,
          thumbnailUrl: thumbnailUrl,
          description: description,
        );

  factory SongModel.fromJson(Map<String, dynamic> json) => SongModel(
        id: json['id'] ?? '',
        fileDetail: json['file_detail'] == null ? null : FileDetail.fromJson(json['file_detail']),
        title: json['title'],
        singer: json['singer'],
        lyric: jsonDecode(json['lyric']),
        thumbnailUrl: json['thumbnail_url'],
        description: jsonDecode(json['description']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'file_detail': fileDetail == null ? null : fileDetail!.toJson(),
        'title': title,
        'singer': singer,
        'lyric': lyric,
        'thumbnail_url': thumbnailUrl,
        'description': description,
      };
}

class SongUpload extends _BaseModel<SongUpload> {
  SongUpload({
    String id = '',
    FileDetail? fileDetail,
    String title = '',
    String singer = '',
    String lyric = '',
    String thumbnailUrl = '',
    String description = '',
    this.songPlatformFile,
    this.thumbnailPlatformFile,
    this.isError = false,
  }) : super(
          id: id,
          fileDetail: fileDetail,
          title: title,
          singer: singer,
          lyric: lyric,
          thumbnailUrl: thumbnailUrl,
          description: description,
        );

  PlatformFile? songPlatformFile;
  PlatformFile? thumbnailPlatformFile;
  bool isError;

  factory SongUpload.fromJson(Map<String, dynamic> json) => SongUpload(
        id: json['id'] ?? '',
        fileDetail: json['file_detail'] == null ? null : FileDetail.fromJson(json['file_detail']),
        title: json['title'],
        singer: json['singer'],
        lyric: json['lyric'],
        thumbnailUrl: json['thumbnail_url'],
        description: json['description'],
        songPlatformFile: json['song_platform_file'],
        thumbnailPlatformFile: json['thumbnail_platform_file'],
        isError: json['is_error'] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'file_detail': fileDetail == null ? null : fileDetail!.toJson(),
        'title': title,
        'singer': singer,
        'lyric': lyric,
        'thumbnail_url': thumbnailUrl,
        'description': description,
        'song_platform_file': songPlatformFile,
        'thumbnail_platform_file': thumbnailPlatformFile,
        'is_error': isError,
      };
}

class FileDetail {
  FileDetail({this.name = '-', this.duration = '-', this.url = ''});

  String name;
  String duration;
  String url;

  factory FileDetail.fromJson(Map<String, dynamic> json) =>
      FileDetail(name: json['name'], duration: json['duration'], url: json['url']);

  Map<String, dynamic> toJson() => {'name': name, 'duration': duration, 'url': url};
}

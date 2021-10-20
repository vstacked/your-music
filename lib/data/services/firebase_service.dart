import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:your_music/models/song_model.dart';

class FirebaseService {
  FirebaseService._();
  static final instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> adminAuth() async {
    final data = await _firestore.collection('admin').get();
    if (data.docs.isNotEmpty) return data.docs.first.data();
    return {};
  }

  Future<bool> saveSong(SongModel songModel) async {
    try {
      final _collection = _firestore.collection('songs');
      final song =
          await _storage.ref('songs/${songModel.songPlatformFile!.name}').putData(songModel.songPlatformFile!.bytes!);
      final thumbnail = await _storage
          .ref('thumbnails/${songModel.thumbnailPlatformFile!.name}')
          .putData(songModel.thumbnailPlatformFile!.bytes!);

      await _collection.add({
        'title': songModel.title,
        'singer': songModel.singer,
        'song': await song.ref.getDownloadURL(),
        'thumbnail': await thumbnail.ref.getDownloadURL(),
        'lyric': songModel.lyric ?? '',
        'description': songModel.description ?? '',
        'created_at': DateTime.now().toLocal(),
        'active': true,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> fetchSongs() =>
      _firestore.collection('songs').where('active', isEqualTo: true).orderBy('created_at').snapshots();
}

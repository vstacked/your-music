import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../../models/song_model.dart';
import '../../utils/environment/env.dart';
import 'notification_service.dart';

enum MessageType { added, edited, deleted }

class FirebaseService {
  FirebaseService._() {
    _auth.signInAnonymously();
  }
  static final instance = FirebaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final NotificationService _notification = NotificationService.instance;

  Future<Map<String, dynamic>> _adminAuth() async {
    final data = await _firestore.collection('admin').get();
    if (data.docs.isNotEmpty) return data.docs.first.data();
    return {};
  }

  bool get isLogin {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      _auth.userChanges().first.then((value) {
        firebaseUser = value;
      });
    }
    return _auth.currentUser != null;
  }

  Future<bool?> login(String username, String password) async {
    try {
      final data = await _adminAuth();
      if (data.isEmpty) throw Exception('Error Auth');

      if (username == data['username'] && password == data['password']) return true;

      return false;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<bool> saveOrUpdateSong(SongUpload songModel, {bool isEdit = false}) async {
    try {
      final _collection = _firestore.collection('songs');

      final _template = '${_auth.currentUser!.uid}-${DateTime.now().toLocal().toIso8601String()}';

      final AudioPlayer audioPlayer = AudioPlayer();

      if (!isEdit) {
        final song = await _storage
            .ref('songs/$_template.${songModel.songPlatformFile!.name.split('.').last}')
            .putData(songModel.songPlatformFile!.bytes!);

        await audioPlayer.setUrl(await song.ref.getDownloadURL());

        final thumbnail = await _storage
            .ref('thumbnails/$_template.${songModel.thumbnailPlatformFile!.name.split('.').last}')
            .putData(songModel.thumbnailPlatformFile!.bytes!);

        await _collection.add({
          'title': songModel.title,
          'singer': songModel.singer,
          'file_detail': {
            'name': songModel.songPlatformFile!.name,
            'url': await song.ref.getDownloadURL(),
            'duration': audioPlayer.duration.toString().split('.').first.substring(2),
          },
          'thumbnail_url': await thumbnail.ref.getDownloadURL(),
          'lyric': songModel.lyric,
          'description': songModel.description,
          'created_at': DateTime.now().toLocal(),
          'active': true,
        });
      } else {
        await _collection.doc(songModel.id).update({
          'title': songModel.title,
          'singer': songModel.singer,
          'lyric': songModel.lyric,
          'description': songModel.description,
        });

        if (songModel.songPlatformFile != null) {
          final song = await _storage
              .ref('songs/$_template.${songModel.songPlatformFile!.name.split('.').last}')
              .putData(songModel.songPlatformFile!.bytes!);

          await audioPlayer.setUrl(await song.ref.getDownloadURL());

          await _collection.doc(songModel.id).update({
            'file_detail': {
              'name': songModel.songPlatformFile!.name,
              'url': await song.ref.getDownloadURL(),
              'duration': audioPlayer.duration.toString().split('.').first.substring(2),
            }
          });
        }

        if (songModel.thumbnailPlatformFile != null) {
          final thumbnail = await _storage
              .ref('thumbnails/$_template.${songModel.thumbnailPlatformFile!.name.split('.').last}')
              .putData(songModel.thumbnailPlatformFile!.bytes!);

          await _collection.doc(songModel.id).update({
            'thumbnail_url': await thumbnail.ref.getDownloadURL(),
          });
        }
      }

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteSong(String id) async {
    try {
      await _firestore.collection('songs').doc(id).update({'active': false});
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> fetchSongs() =>
      _firestore.collection('songs').where('active', isEqualTo: true).orderBy('created_at').snapshots();

  Future<void> sendMessage({required MessageType type, required String title, String songId = ''}) async {
    try {
      String msgId, body;

      switch (type) {
        case MessageType.added:
          msgId = '0';
          body = '$title has been added, Check it out now!';
          break;
        case MessageType.edited:
          msgId = '1';
          body = '$title has been edited, Check it out now!';
          break;
        case MessageType.deleted:
          msgId = '2';
          body = '$title songs are deleted';
          break;
      }

      await http.post(
        Uri.https('fcm.googleapis.com', '/fcm/send'),
        headers: {
          HttpHeaders.authorizationHeader: Env.cloudMessagingKey,
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        body: jsonEncode({
          'to': '/topics/messaging',
          'notification': {'title': 'Your Music', 'body': body},
          'data': {'msg_id': msgId, 'song_id': songId}
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> initMessaging() async {
    _messaging.subscribeToTopic('messaging');

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      _notification.show(message: event);
    });
    FirebaseMessaging.onBackgroundMessage(_messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _notification.selectNotification(jsonEncode(event.data));
    });
  }
}

Future<void> _messageHandler(_) async {
  await Firebase.initializeApp();
}

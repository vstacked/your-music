import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:googleapis_auth/auth_io.dart';

import '../../models/song_model.dart';
import 'notification_service.dart';

enum MessageType { added, edited, deleted }

class FirebaseService {
  final FirebaseFirestore _firestore;

  final FirebaseStorage _storage;

  final FirebaseMessaging _messaging;

  final FirebaseAuth _auth;

  final NotificationService _notification;

  FirebaseService({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseMessaging messaging,
    required FirebaseAuth auth,
    required NotificationService notification,
  })  : _firestore = firestore,
        _storage = storage,
        _messaging = messaging,
        _auth = auth,
        _notification = notification {
    _auth.signInAnonymously();
  }

  AccessToken? _accessToken;

  final _topic = 'your-music';

  Future<Map<String, dynamic>> _adminAuth() async {
    final data = await _firestore.collection('admin').get();
    if (data.docs.isNotEmpty) return data.docs.first.data();
    return {};
  }

  bool get isLogin => _auth.currentUser != null;

  Future<bool?> login(String username, String password) async {
    try {
      final data = await _adminAuth();
      if (data.isEmpty) throw Exception('Error Auth');

      if (username == data['username'] && password == data['password']) {
        return true;
      }

      return false;
    } catch (e, s) {
      debugPrint('$e');
      return null;
    }
  }

  Future<bool> saveSong(SongUpload songModel) async {
    try {
      final _collection = _firestore.collection('songs');

      final _template = '${_auth.currentUser!.uid}-${DateTime.now().toLocal().toIso8601String()}';

      final AudioPlayer audioPlayer = AudioPlayer();

      final songExt = songModel.songPlatformFile!.name.split('.').last;
      final thumbnailExt = songModel.thumbnailPlatformFile!.name.split('.').last;

      final song = await _storage.ref('songs/$_template.$songExt').putData(songModel.songPlatformFile!.bytes!);

      final songUrl = await song.ref.getDownloadURL();

      // using to get audio duration
      await audioPlayer.setUrl(songUrl);
      final songDuration = audioPlayer.duration.toString().split('.').first.substring(2);

      final thumbnail =
          await _storage.ref('thumbnails/$_template.$thumbnailExt').putData(songModel.thumbnailPlatformFile!.bytes!);

      final thumbnailUrl = await thumbnail.ref.getDownloadURL();

      await _collection.add({
        'title': songModel.title,
        'singer': songModel.singer,
        'file_detail': {
          'name': songModel.songPlatformFile!.name,
          'url': songUrl,
          'duration': songDuration,
        },
        'thumbnail_url': thumbnailUrl,
        'lyric': songModel.lyric,
        'description': songModel.description,
        'created_at': DateTime.now().toLocal(),
        'active': true,
      });

      await audioPlayer.dispose();

      return true;
    } catch (e, s) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateSong(SongUpload songModel) async {
    try {
      final _collection = _firestore.collection('songs');

      final _template = '${_auth.currentUser!.uid}-${DateTime.now().toLocal().toIso8601String()}';

      final AudioPlayer audioPlayer = AudioPlayer();

      await _collection.doc(songModel.id).update({
        'title': songModel.title,
        'singer': songModel.singer,
        'lyric': songModel.lyric,
        'description': songModel.description,
      });

      // update song
      if (songModel.songPlatformFile != null) {
        final ext = songModel.songPlatformFile!.name.split('.').last;

        final song = await _storage.ref('songs/$_template.$ext').putData(songModel.songPlatformFile!.bytes!);

        final url = await song.ref.getDownloadURL();

        await audioPlayer.setUrl(url);
        final duration = audioPlayer.duration.toString().split('.').first.substring(2);

        await _collection.doc(songModel.id).update({
          'file_detail': {
            'name': songModel.songPlatformFile!.name,
            'url': url,
            'duration': duration,
          }
        });
      }

      // update thumbnail
      if (songModel.thumbnailPlatformFile != null) {
        final ext = songModel.thumbnailPlatformFile!.name.split('.').last;

        final thumbnail =
            await _storage.ref('thumbnails/$_template.$ext').putData(songModel.thumbnailPlatformFile!.bytes!);

        await _collection.doc(songModel.id).update({
          'thumbnail_url': await thumbnail.ref.getDownloadURL(),
        });
      }

      return true;
    } catch (e, s) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteSong(String id) async {
    try {
      await _firestore.collection('songs').doc(id).update({'active': false});
      return true;
    } catch (e, s) {
      debugPrint(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> fetchSongs() =>
      _firestore.collection('songs').where('active', isEqualTo: true).orderBy('created_at').snapshots();

  Future<QuerySnapshot> fetchSongsAsync() =>
      _firestore.collection('songs').where('active', isEqualTo: true).orderBy('created_at').get();

  Future<void> _getAccessToken() async {
    final secrets = await rootBundle.loadString('assets/secrets.json');
    final map = json.decode(secrets);

    final credentials = ServiceAccountCredentials.fromJson(map);
    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/cloud-platform',
    ];

    final client = http.Client();
    final data = await clientViaServiceAccount(credentials, scopes, baseClient: client);

    client.close();
    _accessToken = data.credentials.accessToken;
  }

  Future<void> sendMessage({
    required MessageType type,
    required String title,
    String songId = '',
  }) async {
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
          body = '$title song(s) are deleted';
          break;
      }

      if (_accessToken?.hasExpired ?? true) await _getAccessToken();

      // migrated to the HTTP v1 API
      await http.post(
        Uri.https(
          'fcm.googleapis.com',
          '/v1/projects/your-music-88879/messages:send',
        ),
        headers: {
          HttpHeaders.authorizationHeader: '${_accessToken!.type} ${_accessToken!.data}',
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
        body: jsonEncode({
          'message': {
            'topic': _topic,
            'notification': {'title': 'Your Music', 'body': body},
            'data': {'msg_id': msgId, 'song_id': songId}
          }
        }),
      );
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }

  Future<void> initMessaging() async {
    _messaging.subscribeToTopic(_topic);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      _notification.show(message: event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      _notification.selectNotification(jsonEncode(event.data));
    });
  }
}

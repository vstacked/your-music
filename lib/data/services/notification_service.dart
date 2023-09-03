import 'dart:collection';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../../models/song_model.dart';
import '../../providers/song_provider.dart';
import '../../ui/my_app.dart';
import '../../utils/routes/routes.dart';

class NotificationService {
  NotificationService._() {
    _init();
  }

  static final instance = NotificationService._();

  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'Your Music Notifications',
  );
  final _initializationSettingsAndroid = const AndroidInitializationSettings('background');
  late final _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(_channel.id, _channel.name),
  );

  Future<void> _init() async {
    final initializationSettings = InitializationSettings(android: _initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => selectNotification(details.payload),
      // onDidReceiveBackgroundNotificationResponse: (details) => selectNotificationBackground(details.payload),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  void selectNotification(String? payload) async {
    if (payload == null) return null;

    final data = jsonDecode(payload);

    if (data['msg_id'] == '0' || data['msg_id'] == '1') {
      final songProvider = navigatorKey.currentContext!.read<SongProvider>();

      songProvider.fetchSongs().listen((event) async {
        if (event.docs.isNotEmpty) {
          final id = data['song_id'];
          final songResult = event.docs.where((e) => e.id == id).toList();

          if (songResult.isNotEmpty) {
            songProvider.detailSong = SongModel.fromJson(
              Map.from(songResult.first.data() as LinkedHashMap)..remove('created_at'),
            )..id = songResult.first.id;

            await navigatorKey.currentState!.pushNamed(Routes.detail);

            // *
            songProvider.detailSong = null;
            if (!songProvider.audioPlayer.playing) {
              songProvider.playedSong = null;
            }
          }
        }
      });
    }
  }

  Future<void> show({required RemoteMessage message}) async {
    if (message.notification == null) return;

    final songProvider = navigatorKey.currentContext!.read<SongProvider>();
    await songProvider.loadPlayer();

    _flutterLocalNotificationsPlugin.show(
      message.notification.hashCode,
      message.notification!.title,
      message.notification!.body,
      _notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}

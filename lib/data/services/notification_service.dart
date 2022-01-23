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

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'Your Music Notifications',
    importance: Importance.max,
  );
  final AndroidInitializationSettings _initializationSettingsAndroid =
      const AndroidInitializationSettings('background');
  late final NotificationDetails _notificationDetails =
      NotificationDetails(android: AndroidNotificationDetails(_channel.id, _channel.name));

  Future<void> _init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(android: _initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      final data = jsonDecode(payload);
      if (data['msg_id'] != '2') {
        final songProvider = navigatorKey.currentContext!.read<SongProvider>();
        songProvider.fetchSongs().listen((event) {
          if (event.docs.isNotEmpty) {
            final songResult = event.docs.where((e) => e.id == data['song_id']).toList();
            if (songResult.isNotEmpty) {
              songProvider.detailSong =
                  SongModel.fromJson(Map.from(songResult.first.data() as LinkedHashMap)..remove('created_at'))
                    ..id = songResult.first.id;
              navigatorKey.currentState!.pushNamed(Routes.detail);
            }
          }
        });
      }
    }
  }

  Future<void> show({required RemoteMessage message}) async {
    if (message.notification != null) {
      _flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        _notificationDetails,
        payload: jsonEncode(message.data),
      );
    }
  }
}

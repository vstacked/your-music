import 'dart:collection';

import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_music/constants/key.dart';
import 'package:your_music/data/services/notification_service.dart';
import 'package:your_music/ui/android/home/widgets/voice_assistant_command_info.dart';
import 'package:your_music/utils/environment/env.dart';

import '../../../constants/colors.dart';
import '../../../models/song_model.dart';
import '../../../providers/song_provider.dart';
import '../../../utils/device/device_layout.dart';
import '../../../utils/routes/routes.dart';
import 'song.dart';
import 'bottom_bar/bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVoiceAssistantActive = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<SongProvider>();
    provider.loadPlayer();

    if (isVoiceAssistantActive) _setupVoiceAssistant();
    _checkNotification();
  }

  void _checkNotification() async {
    final prefs = await SharedPreferences.getInstance();

    // An important note is that each isolate has its own memory so that your shared preferences in foreground will
    // be different from it in background. You can "synchronize" the data by calling SharedPreference.reload() when
    // your app resumes.
    prefs.reload();

    final data = prefs.getString(KeyConstant.prefNotification);
    if (data == null) return;

    final _notification = NotificationService.instance;
    _notification.selectNotification(data);

    prefs.remove(KeyConstant.prefNotification);
  }

  void _setupVoiceAssistant() {
    AlanVoice.addButton(Env.alanSdkKey);

    final provider = context.read<SongProvider>();
    AlanVoice.callbacks.add((command) => provider.voiceAssistantAction(command.data));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (isVoiceAssistantActive) const VoiceAssistantCommandInfo(),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, Routes.favorite),
                icon: const Icon(Icons.favorite),
                iconSize: 30,
                color: greyColor,
                splashRadius: 25,
              )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'SONG',
                    style: textTheme.headline5!.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: context.read<SongProvider>().fetchSongs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'Song Empty..',
                            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor),
                          ),
                        ),
                      );
                    } else if (isTablet(context)) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) {
                              final song = snapshot.data!.docs[i];
                              return Song(
                                song: SongModel.fromJson(Map.from(song.data() as LinkedHashMap)..remove('created_at'))
                                  ..id = song.id,
                                isCard: true,
                              );
                            },
                            childCount: snapshot.data!.docs.length,
                          ),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) {
                            final song = snapshot.data!.docs[i];
                            return Song(
                              song: SongModel.fromJson(Map.from(song.data() as LinkedHashMap)..remove('created_at'))
                                ..id = song.id,
                            );
                          },
                          childCount: snapshot.data!.docs.length,
                        ),
                      );
                    }
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'Something Went Wrong..',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor),
                        ),
                      ),
                    );
                  }
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                },
              ),
            ],
          ),
        ),
        if (context.watch<SongProvider>().playedSong != null) BottomBar(padding: isTablet(context) ? 48 : 16),
      ],
    );
  }
}

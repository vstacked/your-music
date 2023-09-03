import 'dart:collection';

import 'package:alan_voice/alan_voice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isVoiceAssistantActive = false;

  final loopModeNotifier = ValueNotifier(LoopMode.off);
  final shuffleModeNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SongProvider>();
      provider.loadPlayer();
      isVoiceAssistantActive = provider.isVoiceAssistantActive;

      if (isVoiceAssistantActive) _setupVoiceAssistant();
      _checkNotification();
    });
  }

  void _checkNotification() async {
    final prefs = await SharedPreferences.getInstance();

    // An important note is that each isolate has its own memory so that your shared preferences in foreground will
    // be different from it in background. You can "synchronize" the data by calling SharedPreference.reload() when
    // your app resumes.
    prefs.reload();

    final data = prefs.getString(KeyConstant.prefNotification);
    if (data == null) return;

    if (mounted) {
      final provider = context.read<SongProvider>();
      await provider.loadPlayer();
    }

    final notification = NotificationService.instance;
    notification.selectNotification(data);

    prefs.remove(KeyConstant.prefNotification);
  }

  void _setupVoiceAssistant() {
    AlanVoice.addButton(Env.alanSdkKey);

    final provider = context.read<SongProvider>();
    AlanVoice.callbacks.add((command) => provider.voiceAssistantAction(command.data));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final showBottomBar = context.select((SongProvider p) => p.playedSong != null);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (isVoiceAssistantActive) const VoiceAssistantCommandInfo(),
              _IconButton(icon: Icons.favorite, onPressed: () => Navigator.pushNamed(context, Routes.favorite))
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SONG',
                        style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: loopModeNotifier,
                            builder: (context, mode, _) => _IconButton(
                              icon: () {
                                switch (mode) {
                                  case LoopMode.all:
                                    return Icons.repeat_on_outlined;
                                  case LoopMode.one:
                                    return Icons.repeat_one_on_outlined;
                                  default:
                                    return Icons.repeat;
                                }
                              }(),
                              onPressed: () {
                                LoopMode m = mode;

                                switch (m) {
                                  case LoopMode.all:
                                    m = LoopMode.one;
                                    break;
                                  case LoopMode.one:
                                    m = LoopMode.off;
                                    break;
                                  default:
                                    m = LoopMode.all;
                                    break;
                                }

                                loopModeNotifier.value = m;
                                context.read<SongProvider>().setLoopMode(m);
                              },
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: shuffleModeNotifier,
                            builder: (context, shuffled, _) => _IconButton(
                              icon: shuffled ? Icons.shuffle_on_outlined : Icons.shuffle_outlined,
                              onPressed: () {
                                shuffleModeNotifier.value = !shuffled;
                                context.read<SongProvider>().setShuffleMode(!shuffled);
                              },
                            ),
                          ),
                        ],
                      )
                    ],
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
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor),
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
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor),
                        ),
                      ),
                    );
                  }
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                },
              ),
              if (showBottomBar) const SliverToBoxAdapter(child: SizedBox(height: 140))
            ],
          ),
        ),
        if (showBottomBar) BottomBar(padding: isTablet(context) ? 48 : 16),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const _IconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 30,
      color: greyColor,
      splashRadius: 25,
    );
  }
}

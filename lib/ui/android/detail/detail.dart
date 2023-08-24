import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/song_provider.dart';
import '../../../utils/device/device_layout.dart';
import '../../../utils/routes/observer.dart';
import '../../../utils/routes/routes.dart';
import 'slivers/sliver_song_delegate.dart';
import 'slivers/sliver_tab_bar_delegate.dart';

class Detail extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const Detail({super.key, this.onBackPressed});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  double value = 0;
  late final AnimationController _animationController;
  bool isFavorite = false;

  final ValueNotifier<int> _tabIndexNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabIndexNotifier.dispose();
    super.dispose();
  }

  void playAudio() async {
    final provider = context.read<SongProvider>();
    try {
      if (provider.playedSong?.id != provider.detailSong?.id && provider.detailSong != null) {
        provider.playedSong = provider.detailSong;
        provider.audioPlayer.seek(Duration.zero, index: provider.sourceAudioIndex(provider.playedSong!.id));
      }
      if (_animationController.isCompleted && provider.audioPlayer.playing) {
        await provider.audioPlayer.pause();
      } else {
        if (provider.audioPlayer.processingState == ProcessingState.ready && !provider.audioPlayer.playing) {
          await provider.audioPlayer.play();
        }

        provider.audioPlayer.processingStateStream.listen((event) {
          if (event == ProcessingState.completed && provider.audioPlayer.playing) {
            provider.audioPlayer.pause();
            provider.audioPlayer.seek(Duration.zero);
          }
        });
      }
    } catch (e, s) {
      provider.recordError(e, s);
      debugPrint('playAudio() | $e');
    }
  }

  void _getSong() {
    final provider = context.read<SongProvider>();

    provider.audioPlayer.playingStream.listen((isPlayed) {
      if ((isPlayed && provider.detailSong == null) ||
          (provider.playedSong?.id == provider.detailSong?.id && isPlayed)) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<SongProvider>();
    final isPlaylistLoaded = context.select((SongProvider p) => p.isPlayerLoaded);

    _getSong();
    isFavorite = songProvider.favorite.where((element) => element.id == songProvider.detailSong?.id).isNotEmpty;
    return WillPopScope(
      onWillPop: () {
        if (widget.onBackPressed != null) {
          widget.onBackPressed!();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'DETAIL',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20,
            alignment: Alignment.center,
            color: greyColor,
            splashRadius: 25,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              if (widget.onBackPressed != null) {
                widget.onBackPressed!();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                context.read<SongProvider>().setFavorite(song: songProvider.detailSong!, isFavorite: isFavorite);
              },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline),
              iconSize: 30,
              color: greyColor,
              splashRadius: 25,
            )
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: SliverSongDelegate(
                  maxHeight: isTablet(context) ? 220 : 580,
                  sliderValue: value,
                  sliderOnChanged: (value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                  playPauseAnimation: _animationController,
                  onPrevious: songProvider.audioPlayer.hasPrevious && isPlaylistLoaded
                      ? songProvider.audioPlayer.seekToPrevious
                      : null,
                  onPlayPause: () {
                    if (!isPlaylistLoaded) return;

                    final routes = Observer.route.navStack.fetchAll();
                    final a = routes.contains(Routes.favorite);
                    final b = songProvider.isCurrentFavoritePlaylist;

                    if ((a && !b) || (!a && b)) {
                      songProvider.mediaPlaylistUpdate = true;
                      songProvider.loadPlayer().whenComplete(() => playAudio());
                    } else {
                      playAudio();
                    }
                  },
                  onPlayPauseLoading: !isPlaylistLoaded,
                  onNext:
                      songProvider.audioPlayer.hasNext && isPlaylistLoaded ? songProvider.audioPlayer.seekToNext : null,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverTabBarDelegate(onChanged: (value) => _tabIndexNotifier.value = value),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                sliver: SliverToBoxAdapter(
                  child: ValueListenableBuilder<int>(
                    valueListenable: _tabIndexNotifier,
                    builder: (context, index, _) => [
                      Text(songProvider.detailSong?.description ?? songProvider.playedSong?.description ?? ''),
                      Text(songProvider.detailSong?.lyric ?? songProvider.playedSong?.lyric ?? ''),
                    ][index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

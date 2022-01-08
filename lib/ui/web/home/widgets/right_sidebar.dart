import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/providers/song_provider.dart';
import 'package:your_music/ui/web/home/home.dart';
import 'package:your_music/ui/web/home/widgets/dialogs.dart';
import 'package:your_music/utils/routes/routes.dart';
import 'package:your_music/widgets/icon_button_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:your_music/widgets/remove_scrollbar.dart';
import 'package:your_music/widgets/responsive_layout.dart';

class RightSideBar extends StatelessWidget {
  const RightSideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<SongProvider>();
    if (ResponsiveLayout.isSmallScreen(context) || !watch.isOpen) return const SizedBox();

    //* To close drawer rightSidebar
    if (scaffoldKey.currentState!.isEndDrawerOpen && !ResponsiveLayout.isSmallScreen(context)) {
      Future.delayed(const Duration(seconds: 0), () => Navigator.popUntil(context, ModalRoute.withName(Routes.home)));
    }

    return SizedBox(
      width: ResponsiveLayout.isLargeScreen(context) ? 275 : 225,
      height: double.maxFinite,
      child: const _DetailSong(),
    );
  }
}

class SmallRightSidebar extends StatelessWidget {
  const SmallRightSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Drawer(child: _DetailSong());
}

//* --------------------------------------------------------------------------------------------------------------------

class _DetailSong extends StatefulWidget {
  const _DetailSong({Key? key}) : super(key: key);

  @override
  _DetailSongState createState() => _DetailSongState();
}

class _DetailSongState extends State<_DetailSong> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animationController;
  late final AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    audioPlayer = AudioPlayer();
    audioPlayer.playingStream.listen((event) {
      if (event) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addObserver(this);
    _animationController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) audioPlayer.stop();
  }

  Future<void> _setAudio() async {
    try {
      Uri uri = Uri.parse(context.read<SongProvider>().openedSong!.fileDetail!.url);
      _animationController.reset();
      await audioPlayer.stop();
      await audioPlayer.setUrl(uri.toString());
      await audioPlayer.load();
    } catch (e) {
      debugPrint('_setAudio()| $e');
    }
  }

  void playAudio() async {
    try {
      if (_animationController.isCompleted && audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        if (audioPlayer.processingState == ProcessingState.ready && !audioPlayer.playing) await audioPlayer.play();

        audioPlayer.processingStateStream.listen((event) {
          if (event == ProcessingState.completed && audioPlayer.playing) {
            audioPlayer.pause();
            audioPlayer.seek(Duration.zero);
          }
        });
      }
    } catch (e) {
      debugPrint('playAudio() | $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<SongProvider>();
    final textTheme = Theme.of(context).textTheme;
    if (mounted) _setAudio();

    return Material(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.5),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButtonWidget(
                  icon: const Icon(Icons.mode_edit_outline_outlined),
                  iconSize: 30,
                  color: blueColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: overlayColor,
                      routeSettings: const RouteSettings(name: '/editSongDialog'),
                      builder: (context) => songDialog(isEdit: true, songModel: watch.openedSong!),
                    );
                  },
                ),
                IconButtonWidget(
                  icon: const Icon(Icons.close),
                  iconSize: 30,
                  color: greyColor,
                  onPressed: () {
                    if (scaffoldKey.currentState!.isEndDrawerOpen) {
                      Navigator.pop(context);
                    } else {
                      context.read<SongProvider>().setOpenedSong(null);
                    }

                    if (audioPlayer.playing) audioPlayer.stop();
                  },
                )
              ],
            ),
            Expanded(
              child: RemoveScrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Material(
                          child: InkWell(
                            onTap: playAudio,
                            child: Container(
                              height: 190,
                              width: 190,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(watch.openedSong!.thumbnailUrl),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(overlayColor, BlendMode.multiply),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _animationController,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(watch.openedSong!.title, style: textTheme.headline6, textAlign: TextAlign.center),
                      Text(watch.openedSong!.singer,
                          style: textTheme.subtitle1!.copyWith(color: greyColor), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      _detail(context, title: 'Description', content: watch.openedSong!.description),
                      const SizedBox(height: 20),
                      _detail(context, title: 'Lyric', content: watch.openedSong!.lyric),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _detail(BuildContext context, {required String title, required String content}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: double.maxFinite, child: Text(title, style: textTheme.bodyText1)),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ReadMoreText(
            content.isEmpty ? '-' : content,
            style: textTheme.bodyText2!.copyWith(color: greyColor),
            trimMode: TrimMode.Length,
            lessStyle: textTheme.bodyText2!.copyWith(color: blueColor),
            moreStyle: textTheme.bodyText2!.copyWith(color: blueColor),
            trimCollapsedText: 'more',
            trimExpandedText: 'less',
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

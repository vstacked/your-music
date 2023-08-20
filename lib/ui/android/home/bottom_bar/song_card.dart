import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/position_data.dart';
import '../../../../providers/song_provider.dart';

class SongCard extends StatefulWidget {
  const SongCard({super.key, this.onPanUpdate});

  final void Function(DragUpdateDetails details)? onPanUpdate;

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> with SingleTickerProviderStateMixin {
  late final AnimationController _playerController;

  @override
  void initState() {
    super.initState();
    _playerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    context.read<SongProvider>().audioPlayer.playingStream.listen((isPlaying) {
      if (isPlaying) {
        _playerController.forward();
      } else {
        _playerController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final provider = context.watch<SongProvider>();
    return Row(
      children: <Widget>[
        Flexible(
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  StreamBuilder<PositionData>(
                    stream: Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
                      provider.audioPlayer.positionStream,
                      provider.audioPlayer.bufferedPositionStream,
                      provider.audioPlayer.durationStream,
                      (position, bufferedPosition, duration) =>
                          PositionData(position, bufferedPosition, duration ?? Duration.zero),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();

                      final positionData = snapshot.data;
                      return SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          customWidths: CustomSliderWidths(trackWidth: 3, progressBarWidth: 3),
                          customColors: CustomSliderColors(
                            trackColor: Colors.transparent,
                            progressBarColor: blueColor,
                            hideShadow: true,
                          ),
                          size: 100,
                          angleRange: 360,
                          startAngle: 270,
                          infoProperties: InfoProperties(modifier: (_) => ''),
                          animationEnabled: false,
                        ),
                        initialValue: min(
                          (positionData?.position ?? Duration.zero).inMilliseconds.toDouble(),
                          (positionData?.duration ?? Duration.zero).inMilliseconds.toDouble(),
                        ),
                        max: (positionData?.duration ?? Duration.zero).inMilliseconds.toDouble(),
                      );
                    },
                  ),
                  Opacity(
                    opacity: .25,
                    child: CircleAvatar(
                      maxRadius: 24,
                      foregroundImage: NetworkImage(provider.playedSong!.thumbnailUrl),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (provider.audioPlayer.playing) {
                        provider.audioPlayer.pause();
                      } else {
                        provider.audioPlayer.play();
                      }
                    },
                    child: AnimatedIcon(icon: AnimatedIcons.play_pause, progress: _playerController, size: 40),
                  ),
                ],
              ),
              minLeadingWidth: 0,
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              title: Text(
                provider.playedSong!.title,
                style: textTheme.titleMedium!.copyWith(color: greyColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                provider.playedSong!.fileDetail?.duration ?? '-',
                style: textTheme.bodySmall!.copyWith(color: greyColor.withOpacity(.7)),
              ),
            ),
          ),
        ),
        GestureDetector(
          // onPanDown: (_) {
          //   _controller.stop();
          // },
          onPanUpdate: widget.onPanUpdate,
          child: const DecoratedBox(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Row(
              children: <Widget>[
                Icon(Icons.keyboard_arrow_up, size: 35, color: greyColor),
                SizedBox(width: 32.9),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

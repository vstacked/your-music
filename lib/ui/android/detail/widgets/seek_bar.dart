import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../constants/colors.dart';
import '../../../../models/position_data.dart';
import '../../../../providers/song_provider.dart';
import '../shapes/hidden_thumb_shape.dart';
import '../shapes/slider_thumb_shape.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({Key? key, this.hideSlider = false}) : super(key: key);
  final bool hideSlider;

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;

  String durationFormatted(Duration duration) =>
      RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch('$duration')?.group(1) ?? '$duration';

  Duration duration(Duration? duration) {
    if (duration == null) return Duration.zero;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final provider = context.watch<SongProvider>();
    return StreamBuilder<PositionData>(
      stream: Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        provider.audioPlayer.positionStream,
        provider.audioPlayer.bufferedPositionStream,
        provider.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(position, bufferedPosition, duration ?? Duration.zero),
      ),
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        final isPlaying = (provider.playedSong?.id == provider.detailSong?.id) || (provider.detailSong == null);
        if (widget.hideSlider) {
          return Text(
            '${isPlaying ? durationFormatted(duration(positionData?.position)) : '00:00'} / ${isPlaying ? durationFormatted(duration(positionData?.duration)) : provider.detailSong?.fileDetail?.duration}',
            style: textTheme.subtitle2!.copyWith(color: greyColor),
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              isPlaying ? durationFormatted(duration(positionData?.position)) : '00:00',
              style: textTheme.subtitle2!.copyWith(color: greyColor),
            ),
            Expanded(
              child: Stack(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: greyColor.withOpacity(.25),
                      inactiveTrackColor: greyColor,
                      trackHeight: 3,
                      thumbShape: const HiddenThumbShape(),
                    ),
                    child: Slider(
                      min: 0,
                      max: isPlaying ? duration(positionData?.duration).inMilliseconds.toDouble() : 10,
                      value: isPlaying
                          ? min(duration(positionData?.bufferedPosition).inMilliseconds.toDouble(),
                              duration(positionData?.duration).inMilliseconds.toDouble())
                          : 0,
                      onChanged: (value) {
                        // setState(() {
                        //   _dragValue = value;
                        // });
                        // if (widget.onChanged != null) {
                        //   widget.onChanged!(Duration(milliseconds: value.round()));
                        // }
                      },
                      onChangeEnd: (value) {
                        if (isPlaying) {
                          provider.audioPlayer.seek(Duration(milliseconds: value.round()));
                          _dragValue = null;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: blueColor.withOpacity(.5),
                      inactiveTrackColor: Colors.transparent,
                      trackHeight: 3,
                      thumbShape: const SliderThumbShape(),
                    ),
                    child: Slider(
                      min: 0,
                      max: isPlaying ? duration(positionData?.duration).inMilliseconds.toDouble() : 10,
                      value: isPlaying
                          ? min(_dragValue ?? duration(positionData?.position).inMilliseconds.toDouble(),
                              duration(positionData?.duration).inMilliseconds.toDouble())
                          : 0,
                      onChanged: (value) {
                        if (isPlaying) {
                          setState(() => _dragValue = value);
                          provider.audioPlayer.seek(Duration(milliseconds: value.round()));
                        }
                        // setState(() {
                        //   _dragValue = value;
                        // });
                        // if (widget.onChanged != null) {
                        //   widget.onChanged!(Duration(milliseconds: value.round()));
                        // }
                      },
                      onChangeEnd: (value) {
                        if (isPlaying) {
                          provider.audioPlayer.seek(Duration(milliseconds: value.round()));
                          _dragValue = null;
                          setState(() {});
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            Text(
              isPlaying
                  ? durationFormatted(duration(positionData?.duration))
                  : provider.detailSong?.fileDetail?.duration ?? '00:00',
              style: textTheme.subtitle2!.copyWith(color: greyColor),
            ),
          ],
        );
      },
    );
  }
}

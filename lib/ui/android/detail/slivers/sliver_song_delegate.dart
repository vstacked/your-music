import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/song_model.dart';
import '../../../../providers/song_provider.dart';
import '../../../../utils/device/device_layout.dart';
import '../shapes/slider_thumb_shape.dart';

class SliverSongDelegate extends SliverPersistentHeaderDelegate {
  final double sliderValue;
  final ValueChanged<double> sliderOnChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final double maxHeight;
  const SliverSongDelegate({
    required this.sliderValue,
    required this.sliderOnChanged,
    required this.onPrevious,
    required this.onNext,
    required this.maxHeight,
  });

  static const double _minHeight = 100;

  @override
  double get minExtent => _minHeight;

  @override
  double get maxExtent => max(maxHeight, _minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final songProvider = context.watch<SongProvider>();
    double percent = shrinkOffset / (maxExtent - minExtent);
    percent = percent > 1 ? 1 : percent;

    double circleRadius = 75 * (1 - percent);
    circleRadius = circleRadius > 75 ? 75 : (circleRadius < 40 ? 40 : circleRadius);

    double maxIndent = MediaQuery.of(context).size.width >= 768 ? 300 : 130;
    double dividerIndent = maxIndent * (1 - percent);
    dividerIndent = dividerIndent > maxIndent ? maxIndent : (dividerIndent < 0 ? 0 : dividerIndent);

    bool isCollapsed = percent > (isTablet(context) ? .3 : .5);

    return Column(
      children: [
        if (isTablet(context))
          Expanded(child: Row(children: childrenTablet(songProvider.detailSong!, textTheme, circleRadius, isCollapsed)))
        else
          Expanded(
            child: isCollapsed
                ? Row(
                    children: children(
                      songProvider.playedSong ?? songProvider.detailSong!,
                      textTheme,
                      circleRadius,
                      isCollapsed,
                    ),
                  )
                : Column(
                    children: children(
                      songProvider.playedSong ?? songProvider.detailSong!,
                      textTheme,
                      circleRadius,
                      isCollapsed,
                    ),
                  ),
          ),
        Divider(thickness: 2, indent: dividerIndent, endIndent: dividerIndent),
      ],
    );
  }

  List<Widget> childrenTablet(SongModel song, TextTheme textTheme, double circleRadius, bool isCollapsed) => <Widget>[
        const Spacer(),
        CircleAvatar(
          radius: circleRadius,
          backgroundImage: NetworkImage(song.thumbnailUrl),
        ),
        SizedBox(width: isCollapsed ? 20 : 40),
        Expanded(
          flex: isCollapsed ? 2 : 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song.title,
                style: textTheme.subtitle1!.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: greyColor),
              ),
              const SizedBox(height: 8),
              Text(
                song.singer,
                style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
              ),
              if (!isCollapsed) _tabletActions(textTheme, isCollapsed),
            ],
          ),
        ),
        if (isCollapsed) Expanded(flex: 4, child: _tabletActions(textTheme, isCollapsed)),
        const Spacer(),
      ];

  Column _tabletActions(TextTheme textTheme, bool isCollapsed) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '00:00',
                  style: textTheme.subtitle2!.copyWith(color: greyColor),
                ),
                Expanded(
                  child: SliderTheme(
                    data: const SliderThemeData(
                      activeTrackColor: blueColor,
                      inactiveTrackColor: greyColor,
                      trackHeight: 3,
                      thumbShape: SliderThumbShape(),
                    ),
                    child: Slider(
                      onChanged: sliderOnChanged,
                      value: sliderValue,
                      max: 100,
                      min: 0,
                    ),
                  ),
                ),
                Text(
                  '00:00',
                  style: textTheme.subtitle2!.copyWith(color: greyColor),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_previous),
                iconSize: !isCollapsed ? 40 : 30,
                color: greyColor,
                splashRadius: !isCollapsed ? 25 : 20,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow),
                iconSize: !isCollapsed ? 40 : 30,
                color: greyColor,
                splashRadius: !isCollapsed ? 25 : 20,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.skip_next),
                iconSize: !isCollapsed ? 40 : 30,
                color: greyColor,
                splashRadius: !isCollapsed ? 25 : 20,
              ),
            ],
          )
        ],
      );

  List<Widget> children(SongModel song, TextTheme textTheme, double circleRadius, bool isRow) => <Widget>[
        const Spacer(),
        CircleAvatar(
          radius: circleRadius,
          backgroundImage: NetworkImage(song.thumbnailUrl),
        ),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              song.title,
              style: textTheme.subtitle1!.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: greyColor),
            ),
            const SizedBox(height: 8),
            Text(
              song.singer,
              style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
            )
          ],
        ),
        const Spacer(),
        if (!isRow)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '00:00',
                  style: textTheme.subtitle2!.copyWith(color: greyColor),
                ),
                Expanded(
                  child: SliderTheme(
                    data: const SliderThemeData(
                      activeTrackColor: blueColor,
                      inactiveTrackColor: greyColor,
                      trackHeight: 3,
                      thumbShape: SliderThumbShape(),
                    ),
                    child: Slider(
                      onChanged: sliderOnChanged,
                      value: sliderValue,
                      max: 100,
                      min: 0,
                    ),
                  ),
                ),
                Text(
                  '00:00',
                  style: textTheme.subtitle2!.copyWith(color: greyColor),
                ),
              ],
            ),
          ),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRow)
              Text(
                '00:00 / 00:00',
                style: textTheme.subtitle2!.copyWith(color: greyColor),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.skip_previous),
                  iconSize: !isRow ? 40 : 30,
                  color: greyColor,
                  splashRadius: !isRow ? 25 : 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  iconSize: !isRow ? 40 : 30,
                  color: greyColor,
                  splashRadius: !isRow ? 25 : 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.skip_next),
                  iconSize: !isRow ? 40 : 30,
                  color: greyColor,
                  splashRadius: !isRow ? 25 : 20,
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
      ];

  @override
  bool shouldRebuild(SliverSongDelegate oldDelegate) =>
      sliderValue != oldDelegate.sliderValue ||
      sliderOnChanged != oldDelegate.sliderOnChanged ||
      onPrevious != oldDelegate.onPrevious ||
      onNext != oldDelegate.onNext ||
      maxHeight != oldDelegate.maxHeight;
}

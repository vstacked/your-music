import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../models/song_model.dart';
import '../../../../providers/song_provider.dart';
import '../../../../utils/device/device_layout.dart';
import '../widgets/seek_bar.dart';

class SliverSongDelegate extends SliverPersistentHeaderDelegate {
  final double sliderValue;
  final ValueChanged<double> sliderOnChanged;
  final Animation<double> playPauseAnimation;
  final VoidCallback? onPrevious;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final double maxHeight;
  final bool onPlayPauseLoading;

  const SliverSongDelegate({
    required this.sliderValue,
    required this.sliderOnChanged,
    required this.playPauseAnimation,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.maxHeight,
    required this.onPlayPauseLoading,
  });

  static const double _minHeight = 100;

  @override
  double get minExtent => _minHeight;

  @override
  double get maxExtent => max(maxHeight, _minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
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
          Expanded(
              child: Row(
                  children: childrenTablet(
                      songProvider.detailSong ?? songProvider.playedSong, textTheme, circleRadius, isCollapsed)))
        else
          Expanded(
            child: isCollapsed
                ? Row(
                    children: children(
                      songProvider.detailSong ?? songProvider.playedSong,
                      textTheme,
                      circleRadius,
                      isCollapsed,
                      size,
                    ),
                  )
                : Column(
                    children: children(
                      songProvider.detailSong ?? songProvider.playedSong,
                      textTheme,
                      circleRadius,
                      isCollapsed,
                      size,
                    ),
                  ),
          ),
        Divider(thickness: 2, indent: dividerIndent, endIndent: dividerIndent),
      ],
    );
  }

  List<Widget> childrenTablet(SongModel? song, TextTheme textTheme, double circleRadius, bool isCollapsed) => <Widget>[
        const Spacer(),
        CircleAvatar(
          radius: circleRadius,
          backgroundImage: song != null ? NetworkImage(song.thumbnailUrl) : null,
        ),
        SizedBox(width: isCollapsed ? 20 : 40),
        Expanded(
          flex: isCollapsed ? 2 : 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song?.title ?? '-',
                style: textTheme.titleMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: greyColor),
              ),
              const SizedBox(height: 8),
              Text(
                song?.singer ?? '-',
                style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
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
          const SizedBox(height: 30, child: SeekBar()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: onPrevious,
                icon: const Icon(Icons.skip_previous),
                iconSize: !isCollapsed ? 40 : 30,
                color: greyColor,
                splashRadius: !isCollapsed ? 25 : 20,
              ),
              IconButton(
                onPressed: onPlayPause,
                icon: onPlayPauseLoading
                    ? const SizedBox(width: 25, height: 25, child: Center(child: CircularProgressIndicator()))
                    : AnimatedIcon(icon: AnimatedIcons.play_pause, progress: playPauseAnimation),
                iconSize: !isCollapsed ? 40 : 30,
                color: greyColor,
                splashRadius: !isCollapsed ? 25 : 20,
              ),
              IconButton(
                onPressed: onNext,
                icon: const Icon(Icons.skip_next),
                iconSize: !isCollapsed ? 40 : 30,
                color: greyColor,
                splashRadius: !isCollapsed ? 25 : 20,
              ),
            ],
          )
        ],
      );

  List<Widget> children(SongModel? song, TextTheme textTheme, double circleRadius, bool isRow, Size size) => <Widget>[
        const Spacer(),
        CircleAvatar(
          radius: circleRadius,
          backgroundImage: song != null ? NetworkImage(song.thumbnailUrl) : null,
        ),
        const Spacer(),
        SizedBox(
          width: isRow ? size.width / 3 : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                song?.title ?? '-',
                style: textTheme.titleMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: greyColor),
                maxLines: isRow ? 1 : null,
                overflow: isRow ? TextOverflow.ellipsis : null,
              ),
              const SizedBox(height: 8),
              Text(
                song?.singer ?? '-',
                style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
                maxLines: isRow ? 1 : null,
                overflow: isRow ? TextOverflow.ellipsis : null,
              )
            ],
          ),
        ),
        const Spacer(),
        if (!isRow) const Padding(padding: EdgeInsets.symmetric(horizontal: 13), child: SeekBar()),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isRow) const SeekBar(hideSlider: true),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.skip_previous),
                  iconSize: !isRow ? 40 : 30,
                  color: greyColor,
                  splashRadius: !isRow ? 25 : 20,
                ),
                IconButton(
                  onPressed: onPlayPause,
                  icon: onPlayPauseLoading
                      ? const SizedBox(width: 25, height: 25, child: Center(child: CircularProgressIndicator()))
                      : AnimatedIcon(icon: AnimatedIcons.play_pause, progress: playPauseAnimation),
                  iconSize: !isRow ? 40 : 30,
                  color: greyColor,
                  splashRadius: !isRow ? 25 : 20,
                ),
                IconButton(
                  onPressed: onNext,
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

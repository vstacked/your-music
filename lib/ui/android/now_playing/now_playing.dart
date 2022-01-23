import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/song_provider.dart';
import '../../../utils/device/device_layout.dart';
import 'slivers/sliver_song_delegate.dart';
import 'slivers/sliver_tab_bar_delegate.dart';

class NowPlaying extends StatefulWidget {
  final VoidCallback? onBackPressed;
  const NowPlaying({Key? key, this.onBackPressed}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    final songProvider = context.watch<SongProvider>();
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
            // TODO rename to DETAIL
            'NOW PLAYING',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor, fontWeight: FontWeight.w600),
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
              onPressed: () {},
              icon: const Icon(Icons.favorite),
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
                  onPrevious: () {},
                  onNext: () {},
                ),
              ),
              const SliverPersistentHeader(pinned: true, delegate: SliverTabBarDelegate()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                sliver: SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      Text(songProvider.playedSong?.description ?? songProvider.detailSong!.description),
                      Text(songProvider.playedSong?.lyric ?? songProvider.detailSong!.lyric),
                    ],
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

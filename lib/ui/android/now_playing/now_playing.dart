import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../utils/device/device_layout.dart';
import 'slivers/sliver_song_delegate.dart';
import 'slivers/sliver_tab_bar_delegate.dart';

class NowPlaying extends StatefulWidget {
  final VoidCallback onBackPressed;
  const NowPlaying({Key? key, required this.onBackPressed}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
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
            onPressed: widget.onBackPressed,
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
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                sliver: SliverFillRemaining(
                  child: TabBarView(
                    children: [
                      Text('Description'),
                      Text('Lyric'),
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

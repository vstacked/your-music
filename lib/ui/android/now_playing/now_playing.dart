import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import 'slider_thumb_shape.dart';

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
    final TextTheme textTheme = Theme.of(context).textTheme;
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
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              floating: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 100,
                maxHeight: 580,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 56),
                      const CircleAvatar(
                        radius: 75,
                        backgroundImage: NetworkImage('http://placeimg.com/640/480/cats'),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Title',
                        style:
                            textTheme.subtitle1!.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: greyColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Singer',
                        style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
                      ),
                      const SizedBox(height: 64),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        child: Row(
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
                                  onChanged: (value) {
                                    setState(() {
                                      this.value = value;
                                    });
                                  },
                                  value: value,
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
                      const SizedBox(height: 64),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.skip_previous),
                            iconSize: 40,
                            color: greyColor,
                            splashRadius: 25,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow),
                            iconSize: 40,
                            color: greyColor,
                            splashRadius: 25,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.skip_next),
                            iconSize: 40,
                            color: greyColor,
                            splashRadius: 25,
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Divider(thickness: 2, indent: 130, endIndent: 130)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 110,
                    margin: const EdgeInsets.all(8),
                    color: Colors.red,
                  ),
                ),
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 1
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  // 2
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  // 3
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

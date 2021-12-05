import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utils/routes/routes.dart';
import 'song.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, Routes.favorite),
                icon: const Icon(Icons.favorite),
                iconSize: 30,
                color: greyColor,
                splashRadius: 25,
              )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'SONG',
                    style: textTheme.headline5!.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => const Song(),
                  childCount: 100,
                ),
              )
            ],
          ),
        ),
        const BottomBar(),
      ],
    );
  }
}

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  static const double _minHeight = 80;
  Offset _offset = const Offset(0, _minHeight);
  double padding = 16.0, width = 300;
  bool _isOpen = false;

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //     await showModalBottomSheet(
  //         context: context,
  //         builder: (builder) {
  //           return Container(
  //             height: 350.0,
  //             color: Colors.transparent, //could change this to Color(0xFF737373),
  //             //so you don't have to change MaterialApp canvasColor
  //             child: Container(
  //                 decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
  //                 child: const Center(
  //                   child: Text('This is a modal sheet'),
  //                 )),
  //           );
  //         });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final double _maxHeight = MediaQuery.of(context).size.height;
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy.isNegative) {
            _offset = Offset(0, _offset.dy - details.delta.dy);
            width += 5;
            if (padding > 0) padding -= .5;
          } else if (!_isOpen) {
            if (width > 300) width -= 5;
            if (padding <= 16) padding += .5;
          }

          // if (_offset.dy < _BottomBarState._minHeight) {
          //   _offset = const Offset(0, _BottomBarState._minHeight);
          //   width = 300;
          //   _isOpen = false;
          // } else
          if (_offset.dy > _maxHeight / 6 && !_isOpen) {
            Timer.periodic(const Duration(microseconds: 50), (timer) {
              double value = _offset.dy + 10;
              _offset = Offset(0, value);
              width += 5;
              if (padding > 0) padding -= .5;
              if (_offset.dy > _maxHeight) {
                _offset = Offset(0, _maxHeight);
                timer.cancel();
              }
              setState(() {});
            });
            _isOpen = true;
          }
          setState(() {});
        },
        child: AnimatedPadding(
          padding: EdgeInsets.all(padding),
          duration: Duration.zero,
          child: SafeArea(
            child: AnimatedContainer(
              duration: Duration.zero,
              curve: Curves.easeOut,
              height: _offset.dy,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      'NOW PLAYING',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: greyColor, fontWeight: FontWeight.w600),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 35,
                      alignment: Alignment.center,
                      color: greyColor,
                      splashRadius: 25,
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                      onPressed: () {
                        if (_isOpen) {
                          Timer.periodic(const Duration(microseconds: 50), (timer) {
                            double value = _offset.dy - 10;
                            _offset = Offset(0, value);
                            if (width > 300) width -= 5;
                            if (padding <= 16) padding += .5;
                            if (_offset.dy < _minHeight) {
                              _offset = const Offset(0, _minHeight); // makes sure it doesn't go beyond minHeight
                              timer.cancel();
                            }
                            _isOpen = false;
                            setState(() {});
                          });
                        }
                      },
                    ),
                    actions: [
                      IconButton(
                        onPressed: () => Navigator.pushNamed(context, Routes.favorite),
                        icon: const Icon(Icons.favorite),
                        iconSize: 30,
                        color: greyColor,
                        splashRadius: 25,
                      )
                    ]),
                body: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(index.toString()),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // return SlidingUpPanel(
    //   margin: const EdgeInsets.all(16.0),
    //   maxHeight: 900,
    //   isDraggable: true,
    //   panel: const Center(
    //     child: Text('This is the sliding Widget'),
    //   ),
    // );
    // return Align(
    //   alignment: Alignment.bottomCenter,
    //   child: GestureDetector(
    //     onPanUpdate: (details) {
    //       _offset = Offset(0, _offset.dy - details.delta.dy);
    //       if (_offset.dy < _BottomBarState._minHeight) {
    //         _offset = const Offset(0, _BottomBarState._minHeight);
    //       } else if (_offset.dy > _BottomBarState._maxHeight) {
    //         _offset = const Offset(0, _BottomBarState._maxHeight);
    //       }
    //       setState(() {});
    //     },
    //     child: AnimatedContainer(
    //       duration: Duration.zero,
    //       curve: Curves.easeOut,
    //       height: _offset.dy,
    //       // width: _offset.dx,
    //       margin: EdgeInsets.all(margin),
    //       decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
    //     ),
    //   ),
    // );
  }
}

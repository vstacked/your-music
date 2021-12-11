import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../now_playing/now_playing.dart';
import 'song_card.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  static const double _defaultHeight = 75, _defaultPadding = 16, _defaultRadius = 30;

  late final AnimationController _controller;
  late Animation<double> _animationHeight,
      _animationPadding,
      _animationRadius,
      _animationFadePlayer,
      _animationFadeDetail;

  double _height = _defaultHeight, _padding = 16.0, _radius = 30;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 350), vsync: this);

    _animationPadding = Tween<double>(begin: _defaultPadding, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animationRadius = Tween<double>(begin: _defaultRadius, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animationFadePlayer =
        Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _animationFadeDetail = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.addListener(() {
      setState(() {
        _height = _animationHeight.value;
        _padding = _animationPadding.value;
        _radius = _animationRadius.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [secondaryColor.withOpacity(.25), secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [.05, .75],
              ),
            ),
            child: const SizedBox(height: 170, width: double.infinity),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedPadding(
            padding: EdgeInsets.all(_padding),
            duration: Duration.zero,
            child: SafeArea(
              child: Container(
                height: _height,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(_radius),
                  boxShadow: const [BoxShadow(color: primaryColor, offset: Offset(0, 3), blurRadius: 6)],
                ),
                child: Stack(
                  children: [
                    FadeTransition(
                      opacity: _animationFadeDetail,
                      child: NowPlaying(
                        onBackPressed: () {
                          _animationHeight =
                              Tween<double>(begin: _defaultHeight, end: MediaQuery.of(context).size.height)
                                  .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
                          _controller.reverse();
                        },
                      ),
                    ),
                    FadeTransition(
                      opacity: _animationFadePlayer,
                      child: IgnorePointer(
                        ignoring: _animationFadePlayer.value == 0,
                        child: SongCard(
                          onPanUpdate: (details) {
                            if (details.delta.dy.isNegative) {
                              setState(() {
                                _height += -details.delta.dy;
                              });
                            }
                            if (_height >= 100) {
                              _animationHeight = Tween<double>(begin: _height, end: MediaQuery.of(context).size.height)
                                  .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
                              _controller.forward();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

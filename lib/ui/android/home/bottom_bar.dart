import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../../constants/colors.dart';
import '../now_playing.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  // TODO refactor animation

  static const double _minHeight = 75;
  Offset _offset = const Offset(0, _minHeight);
  double padding = 16.0, width = 342;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _maxHeight = MediaQuery.of(context).size.height;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, secondaryColor.withOpacity(.3), secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [.4, .65, 1],
              ),
            ),
            child: const SizedBox(height: 170, width: double.infinity),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dy.isNegative) {
                _offset = Offset(0, _offset.dy - details.delta.dy);
                width += 5;
                if (padding > 0) padding -= .5;
              } else if (!_isOpen) {
                if (width > 342) width -= 5;
                if (padding <= 16) padding += .5;
              }

              if (_offset.dy > _minHeight + 50 && !_isOpen) {
                Timer.periodic(const Duration(microseconds: 1000), (timer) {
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
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: primaryColor, offset: Offset(0, 3), blurRadius: 6)],
                  ),
                  child: Builder(
                    builder: (context) {
                      if (!_isOpen) return _songCard(textTheme);

                      return NowPlaying(
                        onBackPressed: () {
                          if (_isOpen) {
                            Timer.periodic(const Duration(microseconds: 1000), (timer) {
                              double value = _offset.dy - 10;
                              _offset = Offset(0, value);

                              if (width > 300) width -= 5;
                              if (padding <= 16) padding += .5;

                              if (_offset.dy < _minHeight) {
                                _offset = const Offset(0, _minHeight);
                                width = 342;
                                timer.cancel();
                              }

                              _isOpen = false;
                              setState(() {});
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _songCard(TextTheme textTheme) {
    return Row(
      children: <Widget>[
        Flexible(
          child: Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Stack(
                alignment: Alignment.center,
                children: [
                  SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      customWidths: CustomSliderWidths(trackWidth: 3, progressBarWidth: 3),
                      customColors: CustomSliderColors(
                          trackColor: Colors.transparent, progressBarColor: blueColor, hideShadow: true),
                      size: 100,
                      angleRange: 360,
                      startAngle: 270,
                      infoProperties: InfoProperties(modifier: (_) => ''),
                      animationEnabled: false,
                    ),
                    initialValue: 75,
                  ),
                  const Opacity(
                    opacity: .25,
                    child: CircleAvatar(
                      maxRadius: 24,
                      foregroundImage: NetworkImage('http://placeimg.com/640/480/transport'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                    },
                    child: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: _animationController,
                      size: 40,
                    ),
                  )
                ],
              ),
              minLeadingWidth: 0,
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 0,
              title: Text(
                'title',
                style: textTheme.subtitle1!.copyWith(color: greyColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '03:40',
                style: textTheme.caption!.copyWith(color: greyColor.withOpacity(.7)),
              ),
            ),
          ),
        ),
        const Icon(Icons.keyboard_arrow_up, size: 35, color: greyColor),
        const SizedBox(width: 32.9)
      ],
    );
  }
}

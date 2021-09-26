import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/providers/song_provider.dart';
import 'package:your_music/ui/web/home/widgets/dialogs.dart';
import 'package:your_music/widgets/icon_button_widget.dart';
import 'package:your_music/widgets/remove_scrollbar.dart';
import 'package:your_music/widgets/responsive_layout.dart';

import '../home.dart';

class TabHome extends StatelessWidget {
  const TabHome({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RotatedBox(
      quarterTurns: -1,
      child: Column(
        children: <Widget>[
          const _AppBar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('All Songs', style: textTheme.headline5!.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButtonWidget(
                      icon: const Icon(Icons.delete, size: 35),
                      buttonText: 'Remove Selected',
                      isOutlinedButton: context.watch<SongProvider>().isRemove,
                      color: redColor,
                      onPressed: () {
                        final _read = context.read<SongProvider>();
                        if (_read.isRemove) {
                          showDialog(
                            context: context,
                            barrierColor: overlayColor,
                            routeSettings: const RouteSettings(name: '/deleteSongDialog'),
                            builder: deleteSong,
                          );
                        } else {
                          _read.setRemove(true);
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButtonWidget(
                      icon: const Icon(Icons.upload),
                      color: greenColor,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 13.5),
          const _GridItems(),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (ResponsiveLayout.isSmallScreen(context)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButtonWidget(
              icon: const Icon(Icons.menu),
              color: greyColor,
              onPressed: () => scaffoldKey.currentState!.openDrawer(),
            ),
            Text(
              'Your Music',
              style: textTheme.headline5!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 25),
          ],
        ),
      );
    }
    return const SizedBox(height: 75);
  }
}

class _GridItems extends StatelessWidget {
  const _GridItems({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RemoveScrollbar(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount(context)),
            itemCount: 100,
            itemBuilder: (context, index) => _Item(titleIndex: index),
          ),
        ),
      ),
    );
  }

  int crossAxisCount(BuildContext context) {
    bool isOpen = context.watch<SongProvider>().isOpen;
    if (ResponsiveLayout.isLargeScreen(context)) {
      return isOpen ? 6 : 7;
    } else if (ResponsiveLayout.isMediumScreen(context)) {
      return isOpen ? 5 : 6;
    }
    return 4;
  }
}

class _Item extends StatelessWidget {
  const _Item({Key? key, required this.titleIndex}) : super(key: key);
  final int titleIndex;
  @override
  Widget build(BuildContext context) {
    final watch = context.watch<SongProvider>();
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          final _read = context.read<SongProvider>();
          if (_read.isRemove) {
            _read.setRemoveIds(titleIndex);
          } else {
            _read.setOpenedSong(titleIndex);
            if (ResponsiveLayout.isSmallScreen(context)) scaffoldKey.currentState!.openEndDrawer();
          }
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const NetworkImage('https://placeimg.com/640/480/business'),
              fit: BoxFit.cover,
              colorFilter: watch.isRemove ? ColorFilter.mode(overlayColor, BlendMode.multiply) : null,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Builder(
            builder: (_) {
              if (!watch.isRemove) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: watch.containsRemoveId(titleIndex),
                    onChanged: (_) => context.read<SongProvider>().setRemoveIds(titleIndex),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

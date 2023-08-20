import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/models/song_model.dart';
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
    final read = context.read<SongProvider>();
    final watch = context.watch<SongProvider>();
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
                Text('All Songs', style: textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (watch.isRemoveLoading)
                      const SizedBox(height: 15, width: 15, child: CupertinoActivityIndicator()),
                    if (watch.isRemoveFailed)
                      IconButtonWidget(
                        icon: const Icon(Icons.refresh_rounded),
                        color: redColor,
                        onPressed: read.deleteSong,
                      ),
                    IconButtonWidget(
                      icon: const Icon(Icons.delete, size: 35),
                      buttonText: 'Remove Selected',
                      isOutlinedButton: watch.isRemove,
                      color: redColor,
                      onPressed: () {
                        if (read.isRemove) {
                          showDialog(
                            context: context,
                            barrierColor: overlayColor,
                            routeSettings: const RouteSettings(name: '/deleteSongDialog'),
                            builder: deleteSong,
                          );
                        } else {
                          read.setRemove(true);
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    IconButtonWidget(
                      icon: const Icon(Icons.upload),
                      color: greenColor,
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierColor: overlayColor,
                          routeSettings: const RouteSettings(name: '/addSongDialog'),
                          builder: (context) => songDialog(),
                        );
                      },
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
              style: textTheme.headlineSmall!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: context.watch<SongProvider>().fetchSongs(),
          builder: (context, snapshot) {
            final data = snapshot.data;

            if (!snapshot.hasError && data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || data == null) {
              return Center(
                child: Text(
                  'Something Went Wrong..',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor),
                ),
              );
            }

            if (snapshot.hasData && data.docs.isEmpty) {
              return Center(
                child: Text(
                  'Song Empty..',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: greyColor),
                ),
              );
            }

            return RemoveScrollbar(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount(context)),
                itemCount: data.docs.length,
                itemBuilder: (context, index) {
                  final song = data.docs[index];
                  return _Item(
                    song: SongModel.fromJson(Map.from(song.data() as LinkedHashMap)..remove('created_at'))
                      ..id = song.id,
                  );
                },
              ),
            );
          },
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
  const _Item({Key? key, required this.song}) : super(key: key);
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    final watch = context.watch<SongProvider>();
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final read = context.read<SongProvider>();
              if (read.isRemove) {
                read.setRemoveIds(song.id);
              } else {
                if (read.openedSong?.id == song.id) return;
                read.setOpenedSong(null);
                read.setOpenedSong(song);
                if (ResponsiveLayout.isSmallScreen(context)) scaffoldKey.currentState!.openEndDrawer();
              }
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(song.thumbnailUrl),
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
                        value: watch.containsRemoveId(song.id),
                        onChanged: (_) => context.read<SongProvider>().setRemoveIds(song.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

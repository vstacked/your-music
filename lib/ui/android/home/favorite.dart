import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../models/song_model.dart';
import '../../../utils/device/device_layout.dart';
import 'song.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'FAVORITE',
          style: textTheme.subtitle1!.copyWith(color: greyColor, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          iconSize: 20,
          alignment: Alignment.center,
          color: greyColor,
          splashRadius: 25,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (isTablet(context)) {
            return GridView.builder(
              itemBuilder: (_, i) => Song(isCard: true, song: SongModel()),
              itemCount: 100,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
            );
          }
          return ListView.builder(
            itemCount: 100,
            itemBuilder: (_, i) => Song(song: SongModel()),
          );
        },
      ),
    );
  }
}

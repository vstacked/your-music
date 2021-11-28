import 'package:flutter/material.dart';

import '../../constants/colors.dart';
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
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (_, i) => const Song(),
      ),
    );
  }
}

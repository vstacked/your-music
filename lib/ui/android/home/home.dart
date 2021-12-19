import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../utils/device/device_layout.dart';
import '../../../utils/routes/routes.dart';
import '../song.dart';
import 'bottom_bar.dart';

// TODO fetch data & local storage, play audio, voice assistant

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
              if (isTablet(context))
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((_, i) => const Song(isCard: true), childCount: 100),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => const Song(),
                    childCount: 100,
                  ),
                )
            ],
          ),
        ),
        BottomBar(padding: isTablet(context) ? 48 : 16),
      ],
    );
  }
}

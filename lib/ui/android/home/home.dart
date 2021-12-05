import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../utils/routes/routes.dart';
import '../song.dart';
import 'bottom_bar.dart';

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

import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  const SliverTabBarDelegate();

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: secondaryColor,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.16), blurRadius: 6, offset: const Offset(0, 6)),
          ],
        ),
        child: Stack(
          children: [
            TabBar(
              indicatorColor: Colors.transparent,
              labelStyle: textTheme.titleMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              labelColor: greyColor,
              tabs: const [Tab(text: 'Description'), Tab(text: 'Lyric')],
            ),
            const Center(child: VerticalDivider(thickness: 2, indent: 15, endIndent: 15)),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
}

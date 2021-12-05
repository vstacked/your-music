import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class NowPlaying extends StatelessWidget {
  final VoidCallback onBackPressed;
  const NowPlaying({Key? key, required this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      onWillPop: () {
        onBackPressed();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'NOW PLAYING',
            style: Theme.of(context).textTheme.subtitle1!.copyWith(color: greyColor, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 20,
            alignment: Alignment.center,
            color: greyColor,
            splashRadius: 25,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: onBackPressed,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
              iconSize: 30,
              color: greyColor,
              splashRadius: 25,
            )
          ],
        ),
        body: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 56)),
            const SliverToBoxAdapter(
              child: Hero(
                tag: 'image-playing',
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: NetworkImage('http://placeimg.com/640/480/cats'),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 40),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'title-playing',
                      child: Text(
                        'Title',
                        style:
                            textTheme.subtitle1!.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: greyColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Singer',
                      style: textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600, color: greyColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

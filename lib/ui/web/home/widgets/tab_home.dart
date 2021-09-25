import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/widgets/icon_button_widget.dart';
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
          if (ResponsiveLayout.isSmallScreen(context))
            Padding(
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
                    style:
                        textTheme.headline5!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 25),
                ],
              ),
            )
          else
            const SizedBox(height: 75),
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
                      icon: const Icon(Icons.delete),
                      color: redColor,
                      onPressed: () {},
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
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveLayout.isMediumScreen(context)
                        ? 6
                        : (ResponsiveLayout.isSmallScreen(context) ? 4 : 7),
                  ),
                  itemCount: 100,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage('https://placeimg.com/640/480/business'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

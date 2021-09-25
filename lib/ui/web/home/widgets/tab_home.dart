import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/ui/web/home/widgets/dialogs.dart';
import 'package:your_music/widgets/icon_button_widget.dart';
import 'package:your_music/widgets/responsive_layout.dart';

import '../home.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  _TabHomeState createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  bool isOutlinedDelete = false;
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
                      isOutlinedButton: isOutlinedDelete,
                      color: redColor,
                      onPressed: () {
                        if (isOutlinedDelete) {
                          showDialog(context: context, builder: deleteSong, barrierColor: overlayColor);
                        }
                        setState(() {
                          isOutlinedDelete = !isOutlinedDelete;
                        });
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
          _GridItems(isCheckbox: isOutlinedDelete),
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
  const _GridItems({Key? key, required this.isCheckbox}) : super(key: key);
  final bool isCheckbox;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  ResponsiveLayout.isMediumScreen(context) ? 6 : (ResponsiveLayout.isSmallScreen(context) ? 4 : 7),
            ),
            itemCount: 100,
            itemBuilder: (context, index) {
              return _Item(isCheckbox: isCheckbox);
            },
          ),
        ),
      ),
    );
  }
}

class _Item extends StatefulWidget {
  const _Item({Key? key, required this.isCheckbox}) : super(key: key);
  final bool isCheckbox;

  @override
  __ItemState createState() => __ItemState();
}

class __ItemState extends State<_Item> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: widget.isCheckbox ? () => setState(() => isSelected = !isSelected) : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const NetworkImage('https://placeimg.com/640/480/business'),
              fit: BoxFit.cover,
              colorFilter: widget.isCheckbox ? ColorFilter.mode(overlayColor, BlendMode.multiply) : null,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Builder(
            builder: (_) {
              if (!widget.isCheckbox) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => setState(() => isSelected = !isSelected),
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

import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/utils/routes/routes.dart';
import 'package:your_music/widgets/icon_button_widget.dart';
import 'package:your_music/widgets/responsive_layout.dart';

import '../home.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* To close drawer sidebar
    if (scaffoldKey.currentState!.isDrawerOpen && !ResponsiveLayout.isSmallScreen(context)) {
      Future.delayed(const Duration(seconds: 0), () => Navigator.popUntil(context, ModalRoute.withName(Routes.home)));
    }

    if (ResponsiveLayout.isMediumScreen(context)) {
      return const _MediumSidebar();
    } else if (ResponsiveLayout.isSmallScreen(context)) return const SizedBox();
    return const _LargeSidebar();
  }
}

class _LargeSidebar extends StatelessWidget {
  const _LargeSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: double.maxFinite,
      width: 225,
      color: primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            'Your Music',
            style: textTheme.headline5!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 66.67,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: secondaryColor,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBar(
                      unselectedLabelColor: greyColor.withOpacity(.5),
                      labelPadding: EdgeInsets.zero,
                      labelColor: greyColor,
                      indicator: const BoxDecoration(),
                      tabs: <Widget>[_tabMenu()],
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

  Widget _tabMenu() {
    return RotatedBox(
      quarterTurns: -1,
      child: Row(
        children: const [
          SizedBox(width: 10),
          Icon(Icons.home),
          SizedBox(width: 10),
          Text('Home'),
        ],
      ),
    );
  }
}

class _MediumSidebar extends StatelessWidget {
  const _MediumSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: double.maxFinite,
      width: 150,
      color: primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            'Your Music',
            style: textTheme.headline5!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 69,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: secondaryColor,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBar(
                      unselectedLabelColor: greyColor.withOpacity(.5),
                      labelPadding: EdgeInsets.zero,
                      labelColor: greyColor,
                      indicator: const BoxDecoration(),
                      tabs: <Widget>[_tabMenu()],
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

  Widget _tabMenu() {
    return RotatedBox(
      quarterTurns: -1,
      child: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            SizedBox(width: 10),
            Icon(Icons.home),
            SizedBox(width: 10),
            Text('Home'),
          ],
        ),
      ),
    );
  }
}

class SmallSidebar extends StatelessWidget {
  const SmallSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: Material(
        color: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButtonWidget(
                    icon: const Icon(Icons.close),
                    color: greyColor,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Your Music',
                    style:
                        textTheme.headline5!.copyWith(color: greyColor.withOpacity(.75), fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 69,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Material(
                    color: secondaryColor,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        unselectedLabelColor: greyColor.withOpacity(.5),
                        labelPadding: EdgeInsets.zero,
                        labelColor: greyColor,
                        indicator: const BoxDecoration(),
                        tabs: <Widget>[_tabMenu()],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabMenu() {
    return RotatedBox(
      quarterTurns: -1,
      child: Row(children: const [SizedBox(width: 10), Icon(Icons.home), SizedBox(width: 10), Text('Home')]),
    );
  }
}

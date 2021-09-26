import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/ui/web/home/widgets/sidebar.dart';
import 'package:your_music/ui/web/home/widgets/tab_home.dart';
import 'widgets/right_sidebar.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        key: scaffoldKey,
        drawer: const SmallSidebar(),
        endDrawer: const SmallRightSidebar(),
        drawerScrimColor: overlayColor,
        body: Row(
          children: const <Widget>[
            Sidebar(),
            Expanded(
              child: RotatedBox(
                quarterTurns: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: TabBarView(physics: NeverScrollableScrollPhysics(), children: <Widget>[TabHome()]),
                ),
              ),
            ),
            RightSideBar()
          ],
        ),
      ),
    );
  }
}

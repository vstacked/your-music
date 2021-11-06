import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:your_music/constants/colors.dart';
import 'package:your_music/providers/song_provider.dart';
import 'package:your_music/ui/web/home/widgets/sidebar.dart';
import 'package:your_music/ui/web/home/widgets/tab_home.dart';
import 'widgets/queue.dart';
import 'widgets/right_sidebar.dart';
import 'package:provider/provider.dart';

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
        drawerEnableOpenDragGesture: false,
        endDrawer: const SmallRightSidebar(),
        endDrawerEnableOpenDragGesture: false,
        drawerScrimColor: overlayColor,
        body: Stack(
          children: [
            Row(
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
            if (context.watch<SongProvider>().queue.isNotEmpty) const Queue()
          ],
        ),
      ),
    );
  }
}

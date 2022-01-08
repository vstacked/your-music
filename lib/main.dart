import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'constants/colors.dart';
import 'models/favorite_model.dart';
import 'ui/my_app.dart';

DotEnv dotenv = DotEnv();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setPreferredOrientations();
  await dotenv.load(fileName: '.env');

  if (Platform.isAndroid) {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(FavoriteModelAdapter());
    await Hive.openBox<FavoriteModel>('favorites');
  }

  setPathUrlStrategy();
  return runZonedGuarded(
    () async {
      if (!kIsWeb) {
        runApp(
          FutureBuilder(
            future: Future.delayed(const Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(home: _Splash());
              }
              return const MyApp();
            },
          ),
        );
      } else {
        runApp(const MyApp());
      }
    },
    (e, s) {
      //
    },
  );
}

Future<void> setPreferredOrientations() async {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class _Splash extends StatelessWidget {
  const _Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(child: Text('Your Music', style: Theme.of(context).textTheme.headline4!.copyWith(color: greyColor))),
    );
  }
}

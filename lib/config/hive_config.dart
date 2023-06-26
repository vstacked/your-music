import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/key.dart';
import '../models/favorite_model.dart';

class HiveConfig {
  Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(FavoriteModelAdapter());
    await Hive.openBox<FavoriteModel>(KeyConstant.boxFavorites);
  }
}

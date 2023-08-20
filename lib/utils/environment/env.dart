import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  static String alanSdkKey = dotenv.env['ALAN_SDK_KEY'] ?? '';
}

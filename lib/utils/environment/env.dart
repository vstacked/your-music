import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify()
abstract class Env {
  static const cloudMessagingKey = _Env.cloudMessagingKey;
  static const alanSdkKey = _Env.alanSdkKey;
}

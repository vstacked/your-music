import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

public class Application extends FlutterApplication implements PluginRegistrantCallback {

  @Override
  public void onCreate() {
    super.onCreate();
    FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    GeneratedPluginRegistrant.registerWith(registry);
  }
}
package com.example.cic_wps

//import io.flutter.app.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

//class MainActivity: FlutterActivity() {
//  override fun onCreate(savedInstanceState: Bundle?) {
//    super.onCreate(savedInstanceState)
//    GeneratedPluginRegistrant.registerWith(this)
//  }
//}
class MainActivity: FlutterFragmentActivity() {
  override fun configureFlutterEngine(FlutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(FlutterEngine)
  }
}
package com.example.effective_flutter_course

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val ymaps_api_key = BuildConfig.YMAPS_API_KEY

        MapKitFactory.setApiKey(ymaps_api_key)
        super.configureFlutterEngine(flutterEngine)
    }
}

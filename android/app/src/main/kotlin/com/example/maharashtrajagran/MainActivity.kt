package com.mjagran.android

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "deep_link_channel"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        methodChannel?.setMethodCallHandler { call, result ->
            if (call.method == "getInitialLink") {
                result.success(intent?.dataString)
            }
        }
    }

    // Correct onNewIntent override
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // Send deep link to Flutter via the stored MethodChannel
        intent.dataString?.let { link ->
            methodChannel?.invokeMethod("onDeepLink", link)
        }
    }
}

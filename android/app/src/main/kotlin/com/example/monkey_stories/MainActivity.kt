package com.example.monkey_stories

import io.flutter.embedding.android.FlutterActivity
import co.ab180.airbridge.flutter.AirbridgeFlutter
import android.content.Intent

class MainActivity : FlutterActivity() {
    override fun onResume() {
        super.onResume()
        AirbridgeFlutter.trackDeeplink(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}

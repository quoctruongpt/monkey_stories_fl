package com.example.monkey_stories

import com.ryanheise.audioservice.AudioServiceActivity
import co.ab180.airbridge.flutter.AirbridgeFlutter
import android.content.Intent

class MainActivity : AudioServiceActivity() {
    override fun onResume() {
        super.onResume()
        AirbridgeFlutter.trackDeeplink(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}

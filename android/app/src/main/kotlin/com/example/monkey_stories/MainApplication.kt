package com.example.monkey_stories

import co.ab180.airbridge.flutter.AirbridgeFlutter
import android.app.Application

class MainApplication: Application() {
    override fun onCreate() {
        super.onCreate()
        AirbridgeFlutter.initializeSDK(this, "monkeystories", "4554eff61249472db3446ed1331312ef")
    }
}
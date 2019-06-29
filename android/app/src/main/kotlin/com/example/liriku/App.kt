package com.example.liriku

import io.flutter.app.FlutterApplication

class App : FlutterApplication() {

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}
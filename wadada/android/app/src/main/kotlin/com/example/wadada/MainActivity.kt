package com.ssafy.wadada

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import android.util.Log


class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.ssafy.wadada/watch"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
                    DataLayerListenerService.eventSink = eventSink
                }

                override fun onCancel(arguments: Any?) {
                    // Clear the eventSink when not listening
                    DataLayerListenerService.eventSink = null
                }
            }
        )
    }
}

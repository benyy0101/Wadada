package com.ssafy.wadada

import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import android.util.Log
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.ObjectInputStream
import java.io.ObjectOutputStream
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import android.os.Handler
import android.os.Looper

class DataLayerListenerService : WearableListenerService()  {

    companion object {
        var eventSink: EventSink? = null
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        if (messageEvent.path == "/message_path") {
            val messageData = objectFromBytes(messageEvent.data)
            Handler(Looper.getMainLooper()).post {
                eventSink?.success(messageData)
            }
        }
    }



    private fun objectToBytes(`object`: Any): ByteArray {
        val baos = ByteArrayOutputStream()
        val oos = ObjectOutputStream(baos)
        oos.writeObject(`object`)
        return baos.toByteArray()
    }

    private fun objectFromBytes(bytes: ByteArray): Any {
        val bis = ByteArrayInputStream(bytes)
        val ois = ObjectInputStream(bis)
        return ois.readObject()
    }


}


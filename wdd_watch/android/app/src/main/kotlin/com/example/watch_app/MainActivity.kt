package com.example.watch_app

import io.flutter.embedding.android.FlutterActivity

// 추가된 부분
import android.os.Bundle
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import androidx.wear.ambient.AmbientModeSupport


// class MainActivity: FlutterActivity() {
// }

class MainActivity: FlutterActivity(), SensorEventListener {
    private lateinit var sensorManager: SensorManager
    private var heartRateSensor: Sensor? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        heartRateSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE)
    }

    override fun onResume() {
        super.onResume()
        heartRateSensor?.also { heart ->
            sensorManager.registerListener(this, heart, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onPause() {
        super.onPause()
        sensorManager.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        event ?: return
        if (event.sensor.type == Sensor.TYPE_HEART_RATE) {
            val heartRate = event.values[0]
            // 여기서 heartRate 값을 플러터로 보내야 함
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // 센서 정확도 변경 시 처리
    }
}


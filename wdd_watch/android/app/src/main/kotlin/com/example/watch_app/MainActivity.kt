// package com.example.watch_app

// import io.flutter.embedding.android.FlutterActivity

// // 추가된 부분
// import android.os.Bundle
// // import android.hardware.Sensor
// // import android.hardware.SensorEvent
// // import android.hardware.SensorEventListener
// // import android.hardware.SensorManager
// // import androidx.wear.ambient.AmbientModeSupport
// // import sun.management.Sensor


// class MainActivity: FlutterActivity() {
// }

// // class MainActivity: FlutterActivity(), SensorEventListener {
// //     private lateinit var sensorManager: SensorManager
// //     private var heartRateSensor: Sensor? = null

// //     override fun onCreate(savedInstanceState: Bundle?) {
// //         super.onCreate(savedInstanceState)
// //         sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
// //         heartRateSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE)
// //     }

// //     override fun onResume() {
// //         super.onResume()
// //         heartRateSensor?.also { heart ->
// //             sensorManager.registerListener(this, heart, SensorManager.SENSOR_DELAY_NORMAL)
// //         }
// //     }

// //     override fun onPause() {
// //         super.onPause()
// //         sensorManager.unregisterListener(this)
// //     }

// //     override fun onSensorChanged(event: SensorEvent?) {
// //         event ?: return
// //         if (event.sensor.type == Sensor.TYPE_HEART_RATE) {
// //             val heartRate = event.values[0]
// //             // 여기서 heartRate 값을 플러터로 보내야 함
// //         }
// //     }

// //     override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
// //         // 센서 정확도 변경 시 처리
// //     }


// //     private lateinit var channel: MethodChannel

// //     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
// //         super.configureFlutterEngine(flutterEngine)
// //         channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.watch_app/heart_rate")
// //         channel.setMethodCallHandler { call, result ->
// //             // 필요한 경우 메소드 호출 처리
// //         }
// //     }

// //     val heartRate = event.values[0]
// //     channel.invokeMethod("updateHeartRate", heartRate)      

// // }

// -----------------------------------------
// package com.example.watch_app

// import android.os.Bundle
// import android.content.Context
// import android.hardware.Sensor
// import android.hardware.SensorEvent
// import android.hardware.SensorEventListener
// import android.hardware.SensorManager
// import android.util.Log   // 이거 한줄 추가
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.plugin.common.MethodChannel
// import com.sun.tools.javac.util.Log
// import sun.management.Sensor

// class MainActivity: FlutterActivity(), SensorEventListener {
    
//     private lateinit var sensorManager: SensorManager
//     private var heartRateSensor: Sensor? = null
//     private lateinit var channel: MethodChannel
//     private var lastHeartRate: Float = 0.0f // 최근 심박수를 저장할 변수

//     override fun onCreate(savedInstanceState: Bundle?) {
//         super.onCreate(savedInstanceState)
//         sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
//         heartRateSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE)
        
//         // Flutter랑 통신
//         channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "com.example.watch_app/heart_rate")
//         channel.setMethodCallHandler { call, result ->
//             if (call.method == "getHeartRate") {
//                 // Flutter에서 심박수 데이터 요청 시 현재 가지고 있는 데이터를 바로 반환
//                 // 실제로는 센서 이벤트 리스너에서 받은 최신 데이터를 반환해야 함
//                 // result.notImplemented() // 실제 구현 필요

//                 // Flutter에서 심박수 데이터 요청 시 최근에 저장된 심박수 데이터를 반환
//                 if (lastHeartRate != 0.0f) {
//                     result.success(lastHeartRate)
//                 } else {
//                     result.error("UNAVAILABLE", "Heart rate data not available yet.", null)
//                 }
//             } else {
//                 result.notImplemented()
//             }
//         }
//     }

//     override fun onResume() {
//         super.onResume()
//         heartRateSensor?.also { heart ->
//             sensorManager.registerListener(this, heart, SensorManager.SENSOR_DELAY_NORMAL)
//         }
//     }

//     override fun onPause() {
//         super.onPause()
//         sensorManager.unregisterListener(this)
//     }

//     override fun onSensorChanged(event: SensorEvent?) {
//         event ?: return
//         if (event.sensor.type == Sensor.TYPE_HEART_RATE) {
//             val heartRate = event.values[0]

//             lastHeartRate = heartRate // 심박수를 최근값으로 업데이트

//             // 심박수 데이턱를 로그에 기록
//             Log.d("MainActivity", "심박수: $heartRate")
//             // 심박수 데이터를 Flutter로 전송
//             channel.invokeMethod("updateHeartRate", heartRate)
//         }
//     }
package com.example.watch_app

import android.os.Bundle
import android.content.Context
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.Manifest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

// 추가
import android.util.Log
import android.widget.Toast


class MainActivity: FlutterActivity(), SensorEventListener {

    // private static final String CHANNEL = "com.example.watch_app/heart_rate";
    
    private lateinit var sensorManager: SensorManager
    private var heartRateSensor: Sensor? = null
    private lateinit var channel: MethodChannel
    private var lastHeartRate: Float = 0.0f // 최근 심박수를 저장할 변수

    companion object {
        const val REQUESTED_PERMISSION = Manifest.permission.BODY_SENSORS
        const val REQUEST_PERMISSION_CODE = 1
        // 추가
        const val CHANNEL = "com.example.watch_app/heart_rate"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        //  저 센서 매니저 인스턴스를 얻어야 센서에 관련된 모든 작업 관리 가능함
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val heartRateSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE) // 여기서심박수 센서 겟함
        
        // Flutter랑 통신하는ㄱㅓ 
        channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            // if (call.method == "getHeartRate") {
            //     // Flutter에서 심박수 데이터 요청 시 최근에 저장된 심박수 데이터를 반환
            //     if (lastHeartRate != 0.0f) {
            //         result.success(lastHeartRate)
            //     } else {
            //         result.error("UNAVAILABLE", "Heart rate data not available yet.", null)
            //     }
            // } else {
            //     result.notImplemented()
            // }
            // 추가
            when (call.method) {
                "getHeartRate" -> {
                    if (lastHeartRate != 0.0f) {
                        result.success(lastHeartRate)
                    } else {
                        result.error("아이고 불가능합니다", "Heart rate data not available yet", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        checkPermission()

        // 리스너 등록
        heartRateSensor?.also { heart ->
            sensorManager.registerListener(this, heart, SensorManager.SENSOR_DELAY_NORMAL)

        }
        
    }

    // override fun onPause() {
    //     super.onPause()
    //     sensorManager.unregisterListener(this)
    // }
    

    


    // 1. 센서 권한 확인
    private fun checkPermission() {
        when {
            ContextCompat.checkSelfPermission(this, REQUESTED_PERMISSION) == PackageManager.PERMISSION_GRANTED -> {
                Log.d("MainActivity", "BODY_SENSORS 권한이 이미 부여됨")
            }
            ActivityCompat.shouldShowRequestPermissionRationale(this, REQUESTED_PERMISSION) -> {
                Toast.makeText(this, "심박수 측정을 위해서는 권한이 필요합니다.", Toast.LENGTH_LONG).show()
                ActivityCompat.requestPermissions(this, arrayOf(REQUESTED_PERMISSION), REQUEST_PERMISSION_CODE)
            }
            else -> {
                ActivityCompat.requestPermissions(this, arrayOf(REQUESTED_PERMISSION), REQUEST_PERMISSION_CODE)
            }
        }
    }
    
    // 2. 사용자가 권한 요청에 응답한 후의 처리 확인 (권한부여 여부에 따라 로그 추가 가능)
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // 권한이 부여됨
                Log.d("MainActivity", "BODY_SENSORS 권한 부여됨")
            } else {
                // 권한이 거부됨
                Log.d("MainActivity", "BODY_SENSORS 권한 거부됨")
            }
        }
    }
    

    override fun onSensorChanged(event: SensorEvent?) {
        event ?: return
        if (event.sensor.type == Sensor.TYPE_HEART_RATE) {
            val heartRate = event.values[0]

            lastHeartRate = heartRate // 심박수를 최근값으로 업데이트

            // 심박수 데이턱를 로그에 기록
            Log.d("MainActivity", "심박수: $heartRate")
            // 심박수 데이터를 Flutter로 전송
            channel.invokeMethod("updateHeartRate", heartRate)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // 센서 정확도 변경 시 처리 필요한 경우 여기에 구현
    }
}

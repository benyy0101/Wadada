package com.ssafy.wadada

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
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

// 추가
import android.util.Log
import android.widget.Toast


class MainActivity: FlutterActivity(), SensorEventListener {
    
    private lateinit var sensorManager: SensorManager
    private var heartRateSensor: Sensor? = null
    private var lastHeartRate: Float = 0.0f // 최근 심박수
    
    private lateinit var channelHeartRate: MethodChannel
    // private lateinit var channelData: MethodChannel

    companion object {
        const val REQUESTED_PERMISSION = Manifest.permission.BODY_SENSORS
        const val REQUEST_PERMISSION_CODE = 1
        // 추가
        const val CHANNEL_HEARTRATE = "com.ssafy.wadada/heart_rate"
        // const val CHANNEL = "com.example/data_channel"
    }

    

    // 블루투스 관련 로직
    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
    //         when (call.method)  { 
    //             "sendDataToKotlin" -> {
    //             // val formattedPace = call.argument<String>("formattedPace") ?: "0'00''"
    //             val formattedPace = call.argument<String>("formattedPace")
    //             // val splitHours = call.argument<String>("splitHours")
    //             // val splitMinutes = call.argument<String>("splitMinutes")
    //             // val splitSeconds = call.argument<String>("splitSeconds")


                
    //             // Flutter로 응답 보내기
    //             updatePace(formattedPace ?: "0'00''")

    //             result.success("#데이터 #통신 #성공적")
    //         } else -> result.notImplemented()
    //         }
    //     }
    // }

    // private fun updatePace(pace: String) {
    //     flutterEngine?.dartExecutor?.binaryMessenger?.let {
    //         MethodChannel(it, CHANNEL).invokeMethod("updatePace", pace)
    //     }
    // }
    


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        //  저 센서 매니저 인스턴스를 얻어야 센서에 관련된 모든 작업 관리 가능함
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val heartRateSensor = sensorManager.getDefaultSensor(Sensor.TYPE_HEART_RATE) // 여기서심박수 센서 겟함
        
        // Flutter랑 통신하는ㄱㅓ 
        channelHeartRate = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL_HEARTRATE)
        channelHeartRate.setMethodCallHandler { call, result ->
            when (call.method) {
                "getHeartRate" -> {
                    if (lastHeartRate != 0.0f) {
                        result.success(lastHeartRate)
                    } else {
                        result.error("[심박수] 아이고 불가능합니다..", "Heart rate data not available yet", null)
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









    // // 페이스
    // private fun getCurrentPaceFromSomewhere(): Double {
    //     // 여기서는 임시로 랜덤한 페이스 값을 생성하여 반환합니다.
    //     // 실제로는 워치 앱의 센서 데이터나 다른 소스에서 현재 페이스 값을 가져와야 합니다.
    //     return generateRandomPace()
    // }
    
    // private fun generateRandomPace(): Double {
    //     // 랜덤한 페이스 값을 생성하는 함수
    //     // 예시로 5.0 ~ 10.0 사이의 랜덤한 소수를 생성하여 반환합니다.
    //     return (5.0 + Math.random() * (10.0 - 5.0))
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

            lastHeartRate = heartRate // 심박수업데이트
            // 심박수 데이턱를 로그에 기록
            Log.d("MainActivity", "심박수: $heartRate")

            // 심박수 데이터를 Flutter로 전송
            channelHeartRate.invokeMethod("updateHeartRate", heartRate)
        }
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // 센서 정확도 변경 시 처리 필요한 경우 여기에 구현
    }





    

}


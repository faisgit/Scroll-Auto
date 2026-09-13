package com.faisalansari.scrollauto

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.auto_scroll/gestures"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startAutoScroll" -> {
                    val intervalMs = (call.argument<Number>("intervalMs")?.toLong() ?: 2000L)
                    AutoScrollService.startAutoScroll(intervalMs)
                    result.success(true)
                }
                "stopAutoScroll" -> {
                    AutoScrollService.stopAutoScroll()
                    result.success(true)
                }
                "setInterval" -> {
                    val intervalMs = (call.argument<Number>("intervalMs")?.toLong() ?: 2000L)
                    AutoScrollService.setScrollInterval(intervalMs)
                    result.success(true)
                }
                "isAutoScrollRunning" -> {
                    result.success(AutoScrollService.isAutoScrollRunning())
                }
                "swipe" -> {
                    val startX = (call.argument<Number>("startX")?.toDouble() ?: 500.0).toFloat()
                    val startY = (call.argument<Number>("startY")?.toDouble() ?: 1500.0).toFloat()
                    val endX = (call.argument<Number>("endX")?.toDouble() ?: 500.0).toFloat()
                    val endY = (call.argument<Number>("endY")?.toDouble() ?: 400.0).toFloat()
                    val duration = (call.argument<Number>("duration")?.toLong() ?: 300L)

                    val success = AutoScrollService.performSwipe(startX, startY, endX, endY, duration)
                    result.success(success)
                }
                "isAccessibilityServiceEnabled" -> {
                    result.success(AutoScrollService.isServiceRunning())
                }
                "openAccessibilitySettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}

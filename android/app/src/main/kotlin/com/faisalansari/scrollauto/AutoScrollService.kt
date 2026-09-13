package com.faisalansari.scrollauto

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.content.Context
import android.graphics.Path
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class AutoScrollService : AccessibilityService() {

    companion object {
        var instance: AutoScrollService? = null
        private var isAutoScrolling = false
        private var scrollIntervalMs: Long = 2000
        private val handler = Handler(Looper.getMainLooper())
        private var lastVolumeDownTime: Long = 0

        private val scrollRunnable = object : Runnable {
            override fun run() {
                if (isAutoScrolling && instance != null) {
                    performDefaultSwipe()
                    handler.postDelayed(this, scrollIntervalMs)
                }
            }
        }

        fun toggleAutoScroll(): Boolean {
            if (isAutoScrolling) {
                stopAutoScroll()
            } else {
                startAutoScroll(scrollIntervalMs)
            }
            return isAutoScrolling
        }

        fun startAutoScroll(intervalMs: Long = 2000) {
            scrollIntervalMs = intervalMs
            isAutoScrolling = true
            handler.removeCallbacksAndMessages(null)
            handler.post(scrollRunnable)
            instance?.vibrateFeedback(100)
        }

        fun stopAutoScroll() {
            isAutoScrolling = false
            handler.removeCallbacksAndMessages(null)
            instance?.vibrateFeedback(300)
        }

        fun setScrollInterval(intervalMs: Long) {
            scrollIntervalMs = intervalMs
        }

        fun isAutoScrollRunning(): Boolean {
            return isAutoScrolling
        }

        fun performSwipe(startX: Float, startY: Float, endX: Float, endY: Float, duration: Long): Boolean {
            val service = instance ?: return false
            val path = Path().apply {
                moveTo(startX, startY)
                lineTo(endX, endY)
            }
            val stroke = GestureDescription.StrokeDescription(path, 0, duration)
            val gesture = GestureDescription.Builder().addStroke(stroke).build()
            return service.dispatchGesture(gesture, null, null)
        }

        fun performDefaultSwipe(): Boolean {
            val service = instance ?: return false
            val displayMetrics = service.resources.displayMetrics
            val width = displayMetrics.widthPixels.toFloat()
            val height = displayMetrics.heightPixels.toFloat()

            val startX = if (width > 0) width / 2f else 500f
            val startY = if (height > 0) height * 0.70f else 1400f
            val endY = if (height > 0) height * 0.35f else 500f

            // Dynamic stroke duration based on interval speed for smoother experience
            val duration = (scrollIntervalMs * 0.45).toLong().coerceIn(100L, 500L)
            return performSwipe(startX, startY, startX, endY, duration)
        }

        fun isServiceRunning(): Boolean {
            return instance != null
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onKeyEvent(event: KeyEvent?): Boolean {
        if (event != null && event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
            if (event.action == KeyEvent.ACTION_DOWN) {
                val currentTime = System.currentTimeMillis()
                if (currentTime - lastVolumeDownTime in 50..800) {
                    // Double press Volume Down detected! Toggle Auto Scroll ON/OFF.
                    toggleAutoScroll()
                    lastVolumeDownTime = 0
                    return true
                }
                lastVolumeDownTime = currentTime
            }
        }
        return super.onKeyEvent(event)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onInterrupt() {}

    private fun vibrateFeedback(durationMs: Long) {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                val vibrator = vibratorManager.defaultVibrator
                vibrator.vibrate(VibrationEffect.createOneShot(durationMs, VibrationEffect.DEFAULT_AMPLITUDE))
            } else {
                @Suppress("DEPRECATION")
                val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                if (vibrator.hasVibrator()) {
                    @Suppress("DEPRECATION")
                    vibrator.vibrate(durationMs)
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        stopAutoScroll()
        if (instance == this) {
            instance = null
        }
    }
}

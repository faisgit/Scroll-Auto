import 'package:flutter/services.dart';
import 'package:flutter_screen_overlay/flutter_screen_overlay.dart';

class AutoScrollChannelService {
  static const platform = MethodChannel('com.example.auto_scroll/gestures');

  static Future<bool> isAccessibilityServiceEnabled() async {
    try {
      return await platform.invokeMethod('isAccessibilityServiceEnabled');
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isAutoScrollRunning() async {
    try {
      return await platform.invokeMethod('isAutoScrollRunning');
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isOverlayPermissionGranted() async {
    try {
      return await FlutterScreenOverlay.isPermissionGranted();
    } catch (_) {
      return false;
    }
  }

  static Future<void> openAccessibilitySettings() async {
    try {
      await platform.invokeMethod('openAccessibilitySettings');
    } catch (_) {}
  }

  static Future<void> requestOverlayPermission() async {
    try {
      final isGranted = await isOverlayPermissionGranted();
      if (!isGranted) {
        await FlutterScreenOverlay.requestPermission();
      }
    } catch (_) {}
  }

  static Future<void> startAutoScroll(double scrollSpeedSeconds) async {
    final int intervalMs = (scrollSpeedSeconds * 1000).toInt();
    await platform.invokeMethod('startAutoScroll', {'intervalMs': intervalMs});

    // Floating overlay window disabled for now (code preserved)
    /*
    final bool hasPermission = await isOverlayPermissionGranted();
    if (hasPermission) {
      final bool isActive = await FlutterScreenOverlay.isActive();
      if (!isActive) {
        await FlutterScreenOverlay.showOverlay(
          height: 120,
          width: WindowSize.matchParent,
          alignment: OverlayAlignment.centerRight,
          flag: OverlayFlag.defaultFlag,
          enableDrag: true,
          positionGravity: PositionGravity.right,
        );
      }
    }
    */
  }

  static Future<void> stopAutoScroll() async {
    await platform.invokeMethod('stopAutoScroll');
    final bool isActive = await FlutterScreenOverlay.isActive();
    if (isActive) {
      await FlutterScreenOverlay.closeOverlay();
    }
  }

  static Future<void> setInterval(int intervalMs) async {
    await platform.invokeMethod('setInterval', {'intervalMs': intervalMs});
  }
}

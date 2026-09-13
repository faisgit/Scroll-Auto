import 'package:flutter/material.dart';
import '../services/auto_scroll_service.dart';
import '../widgets/hero_banner_widget.dart';
import '../widgets/speed_slider_widget.dart';
import '../widgets/status_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool _isAutoScrolling = false;
  double _scrollSpeedSeconds = 2.0;
  bool _isServiceEnabled = false;
  bool _isOverlayGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final isEnabled =
        await AutoScrollChannelService.isAccessibilityServiceEnabled();
    final isRunning = await AutoScrollChannelService.isAutoScrollRunning();
    final overlayGranted =
        await AutoScrollChannelService.isOverlayPermissionGranted();

    if (mounted) {
      setState(() {
        _isServiceEnabled = isEnabled;
        _isAutoScrolling = isRunning;
        _isOverlayGranted = overlayGranted;
      });
      debugPrint('Overlay status: $_isOverlayGranted');
    }
  }

  void _startAutoScroll() async {
    await _checkPermissions();
    if (!_isServiceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enable Auto Scroll Accessibility Service in System Settings',
          ),
          duration: Duration(seconds: 3),
        ),
      );
      await AutoScrollChannelService.openAccessibilitySettings();
      return;
    }

    await AutoScrollChannelService.startAutoScroll(_scrollSpeedSeconds);

    if (mounted) {
      setState(() {
        _isAutoScrolling = true;
      });
    }
  }

  void _stopAutoScroll() async {
    await AutoScrollChannelService.stopAutoScroll();

    if (mounted) {
      setState(() {
        _isAutoScrolling = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.phone_android, color: Colors.cyanAccent),
            SizedBox(width: 8),
            Text(
              'Aquos Scroll Auto (スクロール)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF161E2E),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeroBannerWidget(),
            const SizedBox(height: 20),
            StatusCardWidget(
              title: 'Accessibility Service',
              activeSubtitle: 'Granted & Running',
              disabledSubtitle: 'Not Granted (Tap Settings)',
              isGranted: _isServiceEnabled,
              buttonText: 'Settings',
              onPressed: () async {
                await AutoScrollChannelService.openAccessibilitySettings();
                await _checkPermissions();
              },
              icon: Icons.warning_amber_rounded,
              iconBgColor: Colors.amber,
            ),
            // Floating Overlay Status Card hidden for now (code preserved)
            /*
            const SizedBox(height: 12),
            StatusCardWidget(
              title: 'Aquos Controller',
              activeSubtitle: 'Overlay Granted',
              disabledSubtitle: 'Overlay Not Granted',
              isGranted: _isOverlayGranted,
              buttonText: 'Grant',
              onPressed: () async {
                await AutoScrollChannelService.requestOverlayPermission();
                await _checkPermissions();
              },
              icon: Icons.layers_clear,
              iconBgColor: Colors.purple,
            ),
            */
            const SizedBox(height: 24),
            SpeedSliderWidget(
              speedSeconds: _scrollSpeedSeconds,
              onChanged: (value) {
                setState(() {
                  _scrollSpeedSeconds = value;
                });
                final int intervalMs = (value * 1000).toInt();
                AutoScrollChannelService.setInterval(intervalMs);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isAutoScrolling ? null : _startAutoScroll,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      _isAutoScrolling ? "Scrolling..." : "Start Auto Scroll",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: !_isAutoScrolling ? null : _stopAutoScroll,
                    icon: const Icon(Icons.stop_rounded),
                    label: const Text("Stop"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade200,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.volume_down, color: Colors.white70, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tip: Double-press Volume Down anytime on your device to instantly toggle Auto Scroll on/off!',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

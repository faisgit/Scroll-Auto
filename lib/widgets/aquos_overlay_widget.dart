import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_overlay/flutter_screen_overlay.dart';

const _overlayChannel = MethodChannel('com.example.auto_scroll/gestures');

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AquosOverlayWidget(),
    ),
  );
}

class AquosOverlayWidget extends StatefulWidget {
  const AquosOverlayWidget({super.key});

  @override
  State<AquosOverlayWidget> createState() => _AquosOverlayWidgetState();
}

class _AquosOverlayWidgetState extends State<AquosOverlayWidget> {
  bool _isScrolling = true;
  bool _isExpanded = false;
  double _speedMultiplier = 1.0;

  void _toggleAutoScroll() async {
    try {
      final bool isCurrentlyRunning = await _overlayChannel.invokeMethod('isAutoScrollRunning');
      if (isCurrentlyRunning || _isScrolling) {
        await _overlayChannel.invokeMethod('stopAutoScroll');
        setState(() {
          _isScrolling = false;
        });
      } else {
        final int intervalMs = (2000 / _speedMultiplier).round();
        await _overlayChannel.invokeMethod(
          'startAutoScroll',
          {'intervalMs': intervalMs},
        );
        setState(() {
          _isScrolling = true;
        });
      }
    } catch (e) {
      debugPrint('Overlay toggle error: $e');
    }
  }

  void _changeSpeed(double newMultiplier) async {
    setState(() {
      _speedMultiplier = newMultiplier;
    });
    final int intervalMs = (2000 / _speedMultiplier).round();
    try {
      await _overlayChannel.invokeMethod('setInterval', {'intervalMs': intervalMs});
    } catch (e) {
      debugPrint('Speed update error: $e');
    }
  }

  void _closeOverlay() async {
    try {
      await _overlayChannel.invokeMethod('stopAutoScroll');
      await FlutterScreenOverlay.closeOverlay();
    } catch (e) {
      debugPrint('Overlay close error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: _isExpanded ? Alignment.center : Alignment.centerRight,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: !_isExpanded
              // Collapsed Mode: Compact floating circle bubble (like screen recording floaters)
              ? InkWell(
                  key: const ValueKey('collapsed_bubble'),
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _isScrolling
                            ? [const Color(0xFF0EA5E9), const Color(0xFF0284C7)]
                            : [const Color(0xFF475569), const Color(0xFF1E293B)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isScrolling ? Colors.cyanAccent : Colors.black)
                              .withValues(alpha: 0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(
                        color: _isScrolling ? Colors.cyanAccent : Colors.white24,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          _isScrolling
                              ? Icons.swap_vert_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isScrolling
                                  ? Colors.greenAccent
                                  : Colors.amberAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              // Expanded Mode: Full width horizontal pill controls bar (spanning whole screen width)
              : Container(
                  key: const ValueKey('expanded_pill'),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isScrolling
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [const Color(0xFF334155), const Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent
                            .withValues(alpha: _isScrolling ? 0.35 : 0.1),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                    border: Border.all(
                      color: _isScrolling
                          ? Colors.cyanAccent.withValues(alpha: 0.6)
                          : Colors.white24,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Collapse back to circle button
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            color: Colors.cyanAccent,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      // Play / Pause Button
                      InkWell(
                        onTap: _toggleAutoScroll,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _isScrolling
                                ? Colors.cyanAccent
                                : Colors.grey.shade700,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isScrolling ? Icons.pause : Icons.play_arrow_rounded,
                            color: _isScrolling ? Colors.black : Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Status Text
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isScrolling
                                      ? Colors.greenAccent
                                      : Colors.amberAccent,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isScrolling ? 'SCROLL AUTO' : 'PAUSED',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${_speedMultiplier.toStringAsFixed(1)}x Speed',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [0.5, 1.0, 1.5, 2.0].map((speed) {
                              final isSelected = _speedMultiplier == speed;
                              return InkWell(
                                onTap: () => _changeSpeed(speed),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.cyanAccent
                                        : Colors.white10,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${speed}x',
                                    style: TextStyle(
                                      color: isSelected ? Colors.black : Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Close button
                      InkWell(
                        onTap: _closeOverlay,
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white54,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

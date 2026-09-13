import 'package:flutter/material.dart';

class SpeedSliderWidget extends StatelessWidget {
  final double speedSeconds;
  final ValueChanged<double> onChanged;

  const SpeedSliderWidget({
    super.key,
    required this.speedSeconds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161E2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Scroll Pace / Interval',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${speedSeconds.toStringAsFixed(1)} sec / swipe',
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: speedSeconds,
            min: 0.5,
            max: 4.0,
            divisions: 7,
            activeColor: Colors.cyanAccent,
            inactiveColor: Colors.white10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

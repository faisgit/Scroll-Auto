import 'package:flutter/material.dart';

class HeroBannerWidget extends StatelessWidget {
  const HeroBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan.shade900, Colors.indigo.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.touch_app_rounded, size: 48, color: Colors.cyanAccent),
          const SizedBox(height: 10),
          const Text(
            'Japanese Phone Auto-Scroll Engine',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Replicating the famous Sharp Aquos "Scroll Auto" feature. Hands-free reading across Web, Twitter/X, & News apps.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.cyan.shade100),
          ),
        ],
      ),
    );
  }
}

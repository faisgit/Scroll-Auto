import 'package:flutter/material.dart';

class StatusCardWidget extends StatelessWidget {
  final String title;
  final String activeSubtitle;
  final String disabledSubtitle;
  final bool isGranted;
  final String buttonText;
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconBgColor;

  const StatusCardWidget({
    super.key,
    required this.title,
    required this.activeSubtitle,
    required this.disabledSubtitle,
    required this.isGranted,
    required this.buttonText,
    required this.onPressed,
    required this.icon,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF161E2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isGranted
                  ? Colors.green.withValues(alpha: 0.2)
                  : iconBgColor.withValues(alpha: 0.2),
              child: Icon(
                isGranted ? Icons.check_circle : icon,
                color: isGranted ? Colors.greenAccent : iconBgColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isGranted
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isGranted
                                ? Colors.greenAccent
                                : Colors.redAccent,
                          ),
                        ),
                        child: Text(
                          isGranted ? 'ENABLED' : 'DISABLED',
                          style: TextStyle(
                            color: isGranted
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isGranted ? activeSubtitle : disabledSubtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isGranted ? Colors.greenAccent : Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: Text(
                isGranted ? 'Granted' : buttonText,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

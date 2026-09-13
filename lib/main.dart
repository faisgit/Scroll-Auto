import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

export 'widgets/aquos_overlay_widget.dart' show overlayMain;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AquosAutoScrollApp());
}

class AquosAutoScrollApp extends StatelessWidget {
  const AquosAutoScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sharp Aquos Scroll Auto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF161E2E),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

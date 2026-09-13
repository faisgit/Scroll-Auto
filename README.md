# 📱 Scroll Auto (スクロールオート)

An open-source Android application built with **Flutter** and **Kotlin** that brings the iconic Japanese **Sharp Aquos "Scroll Auto"** feature to any Android device. It enables hands-free continuous automated scrolling across long web pages, news articles, social feeds (Twitter/X, Reddit, Instagram), and e-books using native gesture injection and physical hardware button shortcuts.

---

## ✨ Features

- **🔊 Hardware Volume Button Shortcut**:
  - Double-press the physical **Volume Down** key anywhere on your phone to instantly start or pause auto-scrolling without touching the screen.
- **⚡ Smooth Native Swipe Engine**:
  - Calculates dynamic stroke duration and swipe distances tailored to chosen speeds using Android's native `AccessibilityService` API.
- **📊 Real-time Permission Status Dashboard**:
  - Live **`ENABLED` / `DISABLED`** badges for Accessibility Service with auto-refresh on app resume.
- **⏱️ Adjustable Pace & Interval**:
  - On-the-fly scroll pace slider (`0.5s` to `4.0s` per swipe).

---

## 🏗️ Architecture & Project Structure

The codebase follows a modular clean architecture separating UI components, platform channels, and native Android accessibility handlers:

```
lib/
├── main.dart                          # App entrypoint & MaterialApp configuration
├── screens/
│   └── home_screen.dart               # Main app dashboard screen
├── services/
│   └── auto_scroll_service.dart       # MethodChannel bridge for Android native calls
└── widgets/
    ├── hero_banner_widget.dart        # Dashboard header banner
    ├── speed_slider_widget.dart       # Speed control pace slider component
    └── status_card_widget.dart        # Accessibility permission status card

android/app/src/main/kotlin/com/faisalansari/scrollauto/
├── MainActivity.kt                    # MethodChannel handler mapping Dart to Kotlin
├── AutoScrollService.kt              # Android AccessibilityService handling swipe gestures & key events
└── AutoScrollTileService.kt          # Quick Settings Notification Bar tile handler
```

---

## ⚙️ Prerequisites & Permissions

Auto-scrolling across system applications requires one primary Android system permission:

1. **Accessibility Service (`AutoScrollService`)**:
   - Required to perform automated touch swipe gestures on screen and intercept physical hardware double-press volume key events.

### 🛡️ Troubleshooting Android 13 / 14 "Restricted Setting" Warning:
If side-loading the APK shows **"Restricted setting: For your security, this setting is currently unavailable"** when trying to enable Accessibility:

1. Go to your phone's **Settings -> Apps -> Scroll Auto**.
2. Tap the **3 vertical dots (⋮)** in the top right corner.
3. Tap **"Allow restricted settings"** and confirm with your PIN/fingerprint.
4. Return to **Accessibility Settings -> Installed Apps -> Scroll Auto** and switch the toggle **ON**.

---

## 📥 Download & Installation Guide

### Option A: Install Direct APK on Phone
1. Download the pre-compiled [`app-release.apk`](file:///c:/Users/fa171/Desktop/auto_scroll_screen/build/app/outputs/flutter-apk/app-release.apk).
2. Transfer or open the APK file on your Android device.
3. If Google Play Protect shows *"App blocked to protect your device"*:
   - Tap **"More details"** -> Tap **"Install anyway"**.
4. If Android 13/14 shows *"Restricted setting"*:
   - Open phone **Settings -> Apps -> Scroll Auto**.
   - Tap **3 vertical dots (⋮)** in top right -> Tap **"Allow restricted settings"**.
5. Launch **Scroll Auto** -> Tap **Settings** -> Enable **Auto Scroll Service** under Installed/Downloaded Apps.

---

## 🚀 Building from Source

### 1. Clone & Setup
Clone the repository and install Flutter dependencies:
```bash
git clone https://github.com/your-username/scrollauto.git
cd scrollauto
flutter pub get
```

### 2. Build Release APK
Generate the release APK:
```bash
flutter build apk --release
```
The compiled APK will be available at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## 🎮 How To Use

1. Open **Scroll Auto** on your device.
2. Tap **"Start Auto Scroll"** on the dashboard.
3. Switch to any target application (Web Browser, Twitter/X, Reddit, News, Kindle).
4. Double-press **Volume Down** on your phone anytime to start or pause auto-scrolling hands-free!

---

## 🛠️ Tech Stack & Packages

- **Flutter / Dart** (`^3.13.1`)
- **Android Kotlin** (`com.faisalansari.scrollauto`)
- **Flutter Packages**:
  - `flutter_accessibility_service: ^1.2.0`

---

## 📄 License
This project is open-source and available under the [MIT License](LICENSE).

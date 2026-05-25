# Fast as Lightning ⚡

A modern, high-performance GPS sport tracker built with Flutter. Track your running, cycling, and walking activities with real-time stats and detailed route mapping.

## Features

✨ **Real-time GPS Tracking**
- Accurate location tracking using device GPS
- High precision location updates
- Real-time speed and altitude monitoring

🏃 **Multiple Activity Types**
- Running
- Cycling
- Walking

📊 **Detailed Statistics**
- Total distance traveled
- Average speed
- Current speed and altitude
- Duration tracking

💾 **Local Storage**
- SQLite database for offline activity history
- Complete activity persistence

🎨 **Beautiful UI**
- Material Design 3
- Dark mode support
- Responsive layouts

## Getting Started

### Prerequisites

- Flutter SDK (^3.0.0)
- Dart SDK (included with Flutter)
- Android SDK (for Android testing)
- Xcode (for iOS testing)

### Installation

1. Clone the repository
```bash
git clone https://github.com/lightningwaveNL/Fast-as-Ligtning.git
cd Fast-as-Ligtning
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── activity.dart
├── providers/
│   ├── location_provider.dart
│   └── activity_provider.dart
├── screens/
│   ├── home_screen.dart
│   └── tracking_screen.dart
├── services/
│   └── database_service.dart
└── widgets/
    ├── activity_card.dart
    ├── activity_type_selector.dart
    └── stats_display.dart
```

## Usage

1. Tap "New Activity" to start tracking
2. Select your activity type
3. Tap "Start Tracking" to begin
4. View real-time statistics
5. Tap "Stop Tracking" when finished
6. Activity is automatically saved

## License

MIT License

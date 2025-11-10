# Mobile App - Intención de Siembra

Flutter mobile application for agricultural planting intention management.

## Features

### Implemented Requirements

- ✅ **Harvest Alarm**: One week before harvest notification based on variety cycle
- ✅ **Fruit Sampling Form**: Complete form with photos, brix readings, and observations
- ✅ **Replanting Form**: Track additional seeds used for replanting

## Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **HTTP** - API communication
- **Image Picker** - Camera and gallery access
- **Flutter Local Notifications** - Local notifications
- **Shared Preferences** - Local storage

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode
- Backend API running

## Installation

### Setup Flutter

1. Install Flutter: https://docs.flutter.dev/get-started/install

2. Verify installation:
```bash
flutter doctor
```

### Install Dependencies

```bash
flutter pub get
```

### Configure API Endpoint

Edit `lib/services/api_service.dart` and update the `baseUrl`:

```dart
// For Android Emulator
static const String baseUrl = 'http://10.0.2.2:5000/api';

// For iOS Simulator
static const String baseUrl = 'http://localhost:5000/api';

// For Real Device (replace with your computer's IP)
static const String baseUrl = 'http://192.168.1.X:5000/api';
```

## Running the App

### Android

```bash
flutter run -d android
```

### iOS

```bash
flutter run -d ios
```

### Debug Mode

```bash
flutter run --debug
```

### Release Mode

```bash
flutter run --release
```

## Building

### Android APK

```bash
flutter build apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle
```

### iOS

```bash
flutter build ios
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and distribute.

## App Features

### Home Screen

- View all planting forms
- See harvest notifications for forms within 7 days of expected harvest
- Confirm or change harvest dates
- Navigate to sampling and replanting forms

### Harvest Notifications

- Automatic notification one week before expected harvest
- Based on variety's average cycle days
- Ability to confirm or update harvest date
- Visual alerts on home screen for upcoming harvests

### Fruit Sampling Form

- Select planting form
- Add multiple brix readings with locations
- Take or select multiple photos
- Add observations
- Auto-fills farm, lot, and variety from selected planting form

### Replanting Form

- Select planting form
- Specify number of additional seeds used
- Enter reason for replanting
- Optional: affected area
- Add observations

### Notifications Screen

- View all received notifications
- Clear notification history

## Project Structure

```
mobile/
├── lib/
│   ├── models/
│   │   ├── variety.dart
│   │   ├── planting_form.dart
│   │   ├── sampling_form.dart
│   │   └── replanting_form.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── sampling_form_screen.dart
│   │   ├── replanting_form_screen.dart
│   │   └── notifications_screen.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   └── notification_service.dart
│   ├── widgets/          # (future)
│   ├── utils/            # (future)
│   └── main.dart
├── android/              # Android platform files
├── ios/                  # iOS platform files
├── pubspec.yaml         # Dependencies
└── README.md
```

## Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSCameraUsageDescription</key>
<string>Need camera access to take photos for sampling</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Need photo library access to select photos</string>
```

## Dependencies

Main dependencies in `pubspec.yaml`:

- `provider` - State management
- `http` - HTTP requests
- `shared_preferences` - Local storage
- `image_picker` - Camera/gallery access
- `flutter_local_notifications` - Local notifications
- `intl` - Date formatting

## Development

### Hot Reload

Press `r` in the terminal while the app is running to hot reload changes.

### Hot Restart

Press `R` in the terminal to hot restart the app.

### Debugging

Use Flutter DevTools for debugging:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

## Testing

Run tests:
```bash
flutter test
```

## Troubleshooting

### "Unable to load asset"

Run:
```bash
flutter clean
flutter pub get
```

### Android Build Issues

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS Build Issues

```bash
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter pub get
```

## Future Enhancements

- Offline mode with local database
- Background sync
- Push notifications from server
- Biometric authentication
- GPS location tracking
- QR code scanning for lot identification
- Data export to PDF/Excel
- Multi-language support

## License

ISC

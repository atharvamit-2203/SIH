# StudyFun Flutter App Setup Guide

## 🚨 Current Issue
Your Flutter frontend contains only Dart files but is missing the complete Flutter project structure. I've created the essential files, but you'll need to install Flutter and complete the setup.

## 📋 Prerequisites

### 1. Install Flutter SDK

#### Option A: Using Flutter Installer (Recommended)
1. Visit [Flutter Official Website](https://flutter.dev/docs/get-started/install/windows)
2. Download Flutter SDK for Windows
3. Extract to `C:\flutter` (or any directory without spaces)
4. Add Flutter to your PATH:
   - Open "Environment Variables" in Windows
   - Add `C:\flutter\bin` to your PATH variable

#### Option B: Using Winget (Windows Package Manager)
```powershell
winget install --id=Google.Flutter --exact
```

#### Option C: Using Chocolatey
```powershell
choco install flutter
```

### 2. Install Required Tools

#### Android Studio (Required for Android development)
1. Download and install [Android Studio](https://developer.android.com/studio)
2. Install Android SDK (API level 30 or higher)
3. Install Android SDK Command-line Tools
4. Accept all Android licenses:
   ```powershell
   flutter doctor --android-licenses
   ```

#### Git (Required)
```powershell
winget install --id=Git.Git --exact
```

#### Visual Studio Code (Optional but recommended)
```powershell
winget install --id=Microsoft.VisualStudioCode --exact
```

## 🔧 Setup Steps

### 1. Verify Flutter Installation
```powershell
flutter --version
flutter doctor
```

### 2. Navigate to Your Project
```powershell
cd "D:\SIH\SIH\flutter_sample_frontend"
```

### 3. Get Dependencies
```powershell
flutter pub get
```

### 4. Check for Issues
```powershell
flutter doctor
```
Fix any issues shown by `flutter doctor`.

### 5. Create Missing Platform Files (if needed)
If you get platform-specific errors, run:
```powershell
# For Android
flutter create --org com.studyfun --project-name studyfun_app . --platforms android

# For iOS (if on macOS)
flutter create --org com.studyfun --project-name studyfun_app . --platforms ios

# For Web
flutter create --org com.studyfun --project-name studyfun_app . --platforms web
```

### 6. Run the App

#### For Android Emulator:
1. Open Android Studio
2. Start an Android Virtual Device (AVD)
3. Run the app:
```powershell
flutter run
```

#### For Physical Android Device:
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect via USB
4. Run:
```powershell
flutter devices
flutter run
```

#### For Web:
```powershell
flutter run -d chrome
```

#### For Windows Desktop:
```powershell
flutter config --enable-windows-desktop
flutter run -d windows
```

## 🛠️ Troubleshooting

### Common Issues and Solutions

#### 1. "flutter: The term 'flutter' is not recognized"
- Flutter is not installed or not in PATH
- Follow the Flutter installation steps above
- Restart your terminal after adding to PATH

#### 2. "No connected devices"
- For Android: Start an Android emulator or connect a physical device
- For Web: Use `flutter run -d chrome`
- For Windows: Use `flutter run -d windows`

#### 3. "Gradle build failed"
- Make sure Android Studio is installed
- Accept Android licenses: `flutter doctor --android-licenses`
- Update Android SDK tools in Android Studio

#### 4. "CocoaPods not installed" (iOS/macOS only)
```bash
sudo gem install cocoapods
```

#### 5. Dependencies issues
```powershell
flutter clean
flutter pub get
```

### 6. "Package does not exist" errors
The current Dart files might have import issues. Run:
```powershell
flutter analyze
```
And fix any import or syntax errors.

## 📱 Running Your App

Once everything is set up:

1. **Start your backend** (from the backend directory):
```powershell
cd "D:\SIH\SIH\backend"
python main.py
```

2. **Run your Flutter app**:
```powershell
cd "D:\SIH\SIH\flutter_sample_frontend"
flutter run
```

## 🔗 Connecting Frontend to Backend

Your Flutter app will need to connect to the backend at `http://localhost:5000`. Make sure:

1. Backend is running on `http://localhost:5000`
2. Android emulator can access localhost via `http://10.0.2.2:5000`
3. Physical device can access your computer's IP address

### Update API Base URL

You may need to update the API base URL in your Flutter code:
- For Android Emulator: `http://10.0.2.2:5000`
- For physical device: `http://YOUR_COMPUTER_IP:5000`
- For web: `http://localhost:5000`

## 📂 Project Structure (After Setup)

```
flutter_sample_frontend/
├── lib/
│   ├── main.dart
│   ├── login.dart
│   ├── signup.dart
│   ├── class_page.dart
│   ├── subjects.dart
│   ├── maths_games.dart
│   └── theme_provider.dart
├── android/
├── ios/ (if enabled)
├── web/ (if enabled)
├── pubspec.yaml
└── analysis_options.yaml
```

## 🎯 Quick Start Commands

After installing Flutter, run these commands in order:

```powershell
# Navigate to project
cd "D:\SIH\SIH\flutter_sample_frontend"

# Get dependencies
flutter pub get

# Check everything is working
flutter doctor

# Run the app (make sure you have a device/emulator running)
flutter run
```

## 📞 Need Help?

If you encounter issues:

1. Run `flutter doctor -v` and share the output
2. Check the [Flutter documentation](https://flutter.dev/docs)
3. Ensure all prerequisites are installed correctly

## 🚀 Next Steps

Once your Flutter app is running:
1. Test the login functionality with the backend
2. Verify class selection works
3. Test the math games integration
4. Check theme switching functionality

The app should connect to your Flask backend running on `http://localhost:5000` and provide a complete educational gaming experience!
# StudyFun Flutter Setup Script
# This script helps set up your Flutter development environment

Write-Host "🎓 StudyFun Flutter Setup Script" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Check if Flutter is installed
function Test-Flutter {
    try {
        $flutterVersion = flutter --version 2>$null
        if ($?) {
            Write-Host "✅ Flutter is installed:" -ForegroundColor Green
            Write-Host $flutterVersion
            return $true
        }
    } catch {
        return $false
    }
    return $false
}

# Check if Flutter is installed
if (!(Test-Flutter)) {
    Write-Host "❌ Flutter is not installed or not in PATH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Flutter using one of these methods:" -ForegroundColor Yellow
    Write-Host "1. Download from: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Yellow
    Write-Host "2. Or use winget: winget install --id=Google.Flutter --exact" -ForegroundColor Yellow
    Write-Host "3. Or use chocolatey: choco install flutter" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After installation, restart PowerShell and run this script again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Navigate to the Flutter project
$projectPath = "D:\SIH\SIH\flutter_sample_frontend"
if (!(Test-Path $projectPath)) {
    Write-Host "❌ Project directory not found: $projectPath" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "📁 Navigating to project directory..." -ForegroundColor Blue
Set-Location $projectPath

# Check if pubspec.yaml exists
if (!(Test-Path "pubspec.yaml")) {
    Write-Host "❌ pubspec.yaml not found in project directory" -ForegroundColor Red
    Write-Host "Please make sure you're in the correct Flutter project directory." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Run flutter doctor
Write-Host ""
Write-Host "🔍 Running Flutter doctor to check your environment..." -ForegroundColor Blue
flutter doctor

Write-Host ""
Write-Host "📦 Getting Flutter dependencies..." -ForegroundColor Blue
flutter pub get

# Check for common issues
Write-Host ""
Write-Host "🧪 Analyzing project for issues..." -ForegroundColor Blue
flutter analyze

# Check for available devices
Write-Host ""
Write-Host "📱 Checking for available devices..." -ForegroundColor Blue
flutter devices

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Make sure your backend is running:" -ForegroundColor White
Write-Host "   cd D:\SIH\SIH\backend" -ForegroundColor Gray
Write-Host "   python main.py" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Start an Android emulator or connect a device" -ForegroundColor White
Write-Host ""
Write-Host "3. Run your Flutter app:" -ForegroundColor White
Write-Host "   flutter run" -ForegroundColor Gray
Write-Host ""
Write-Host "For web development, use:" -ForegroundColor White
Write-Host "   flutter run -d chrome" -ForegroundColor Gray
Write-Host ""

$runNow = Read-Host "Would you like to run the app now? (y/n)"
if ($runNow -eq "y" -or $runNow -eq "Y") {
    Write-Host "🚀 Starting Flutter app..." -ForegroundColor Green
    flutter run
} else {
    Write-Host "You can run the app later with: flutter run" -ForegroundColor Blue
}

Read-Host "Press Enter to exit"
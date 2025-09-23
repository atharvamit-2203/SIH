# Quick Setup Check for StudyFun Project
Write-Host "🔍 StudyFun Project Setup Check" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Check Flutter
Write-Host "`n1. Checking Flutter installation..." -ForegroundColor Yellow
try {
    $flutterOutput = flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Flutter is installed" -ForegroundColor Green
        Write-Host $flutterOutput
    } else {
        Write-Host "❌ Flutter not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Flutter not installed or not in PATH" -ForegroundColor Red
}

# Check Python
Write-Host "`n2. Checking Python installation..." -ForegroundColor Yellow
try {
    $pythonOutput = python --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Python is installed: $pythonOutput" -ForegroundColor Green
    } else {
        Write-Host "❌ Python not found" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Python not installed or not in PATH" -ForegroundColor Red
}

# Check project structure
Write-Host "`n3. Checking project structure..." -ForegroundColor Yellow

$backendPath = "D:\SIH\SIH\backend"
$frontendPath = "D:\SIH\SIH\flutter_sample_frontend"

if (Test-Path $backendPath) {
    Write-Host "✅ Backend directory exists" -ForegroundColor Green
    if (Test-Path "$backendPath\main.py") {
        Write-Host "✅ Backend main.py found" -ForegroundColor Green
    } else {
        Write-Host "❌ Backend main.py missing" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Backend directory not found" -ForegroundColor Red
}

if (Test-Path $frontendPath) {
    Write-Host "✅ Frontend directory exists" -ForegroundColor Green
    if (Test-Path "$frontendPath\pubspec.yaml") {
        Write-Host "✅ Flutter pubspec.yaml found" -ForegroundColor Green
    } else {
        Write-Host "❌ Flutter pubspec.yaml missing" -ForegroundColor Red
    }
    if (Test-Path "$frontendPath\lib\main.dart") {
        Write-Host "✅ Flutter main.dart found" -ForegroundColor Green
    } else {
        Write-Host "❌ Flutter main.dart missing" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Frontend directory not found" -ForegroundColor Red
}

# Check Android Studio
Write-Host "`n4. Checking Android Studio..." -ForegroundColor Yellow
$androidStudioPaths = @(
    "${env:ProgramFiles}\Android\Android Studio\bin\studio64.exe",
    "${env:LOCALAPPDATA}\JetBrains\Toolbox\apps\AndroidStudio\ch-0\*\bin\studio64.exe"
)

$androidStudioFound = $false
foreach ($path in $androidStudioPaths) {
    if (Test-Path $path) {
        Write-Host "✅ Android Studio found at: $path" -ForegroundColor Green
        $androidStudioFound = $true
        break
    }
}

if (!$androidStudioFound) {
    Write-Host "❌ Android Studio not found" -ForegroundColor Red
}

# Summary and recommendations
Write-Host "`n📋 SUMMARY & RECOMMENDATIONS" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

$needsFlutter = $false
$needsPython = $false
$needsAndroidStudio = $false

try {
    flutter --version 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { $needsFlutter = $true }
} catch {
    $needsFlutter = $true
}

try {
    python --version 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { $needsPython = $true }
} catch {
    $needsPython = $true
}

if (!$androidStudioFound) { $needsAndroidStudio = $true }

if ($needsFlutter -or $needsPython -or $needsAndroidStudio) {
    Write-Host "`n⚠️  YOU NEED TO INSTALL:" -ForegroundColor Yellow
    
    if ($needsFlutter) {
        Write-Host "📱 Flutter SDK" -ForegroundColor Red
        Write-Host "   Download: https://flutter.dev/docs/get-started/install/windows" -ForegroundColor Gray
        Write-Host "   Or use: winget install --id=Google.Flutter --exact" -ForegroundColor Gray
    }
    
    if ($needsPython) {
        Write-Host "🐍 Python" -ForegroundColor Red
        Write-Host "   Download: https://python.org/downloads/" -ForegroundColor Gray
        Write-Host "   Or use: winget install --id=Python.Python.3.11 --exact" -ForegroundColor Gray
    }
    
    if ($needsAndroidStudio) {
        Write-Host "📱 Android Studio" -ForegroundColor Red
        Write-Host "   Download: https://developer.android.com/studio" -ForegroundColor Gray
    }

    Write-Host "`n🔄 INSTALLATION ORDER:" -ForegroundColor Yellow
    Write-Host "1. Install Python (if missing)" -ForegroundColor White
    Write-Host "2. Install Flutter SDK" -ForegroundColor White
    Write-Host "3. Install Android Studio" -ForegroundColor White
    Write-Host "4. Restart PowerShell" -ForegroundColor White
    Write-Host "5. Run setup scripts" -ForegroundColor White

} else {
    Write-Host "🎉 All required tools are installed!" -ForegroundColor Green
    Write-Host "`n🚀 NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "1. Run: .\setup_flutter.ps1" -ForegroundColor White
    Write-Host "2. Or manually:" -ForegroundColor White
    Write-Host "   - cd D:\SIH\SIH\flutter_sample_frontend" -ForegroundColor Gray
    Write-Host "   - flutter pub get" -ForegroundColor Gray
    Write-Host "   - flutter run" -ForegroundColor Gray
}

Write-Host "`n📖 For detailed setup instructions, see: FLUTTER_SETUP_GUIDE.md" -ForegroundColor Blue
Read-Host "Press Enter to exit"

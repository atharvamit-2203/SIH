Write-Host "StudyFun Project Setup Check" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan

# Check Flutter
Write-Host ""
Write-Host "1. Checking Flutter..." -ForegroundColor Yellow
try {
    flutter --version
    Write-Host "Flutter is installed!" -ForegroundColor Green
} catch {
    Write-Host "Flutter not found - needs to be installed" -ForegroundColor Red
}

# Check Python  
Write-Host ""
Write-Host "2. Checking Python..." -ForegroundColor Yellow
try {
    python --version
    Write-Host "Python is installed!" -ForegroundColor Green
} catch {
    Write-Host "Python not found - needs to be installed" -ForegroundColor Red
}

# Check project files
Write-Host ""
Write-Host "3. Checking project files..." -ForegroundColor Yellow

if (Test-Path "D:\SIH\SIH\backend\main.py") {
    Write-Host "Backend found!" -ForegroundColor Green
} else {
    Write-Host "Backend missing!" -ForegroundColor Red
}

if (Test-Path "D:\SIH\SIH\flutter_sample_frontend\pubspec.yaml") {
    Write-Host "Flutter pubspec.yaml found!" -ForegroundColor Green
} else {
    Write-Host "Flutter pubspec.yaml missing!" -ForegroundColor Red
}

if (Test-Path "D:\SIH\SIH\flutter_sample_frontend\lib\main.dart") {
    Write-Host "Flutter main.dart found!" -ForegroundColor Green
} else {
    Write-Host "Flutter main.dart missing!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Check complete! See FLUTTER_SETUP_GUIDE.md for detailed instructions." -ForegroundColor Blue
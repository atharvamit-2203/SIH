#!/usr/bin/env python3
"""
Setup and test script for StudyFun Backend
This script sets up the backend and runs basic tests to ensure everything works correctly.
"""

import subprocess
import sys
import os
import time
import requests
import json
from threading import Thread

def install_requirements():
    """Install required packages"""
    print("📦 Installing required packages...")
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"])
        print("✅ Packages installed successfully!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install packages: {e}")
        return False

def initialize_database():
    """Initialize the database with sample data"""
    print("🗄️  Initializing database...")
    try:
        subprocess.check_call([sys.executable, "init_db.py"])
        print("✅ Database initialized successfully!")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to initialize database: {e}")
        return False

def start_server():
    """Start the Flask server in a separate thread"""
    print("🚀 Starting Flask server...")
    def run_server():
        os.system(f"{sys.executable} main.py")
    
    server_thread = Thread(target=run_server, daemon=True)
    server_thread.start()
    time.sleep(5)  # Wait for server to start
    return server_thread

def test_endpoints():
    """Test basic API endpoints"""
    base_url = "http://localhost:5000"
    print("🧪 Testing API endpoints...")
    
    tests = [
        {
            "name": "Health Check",
            "method": "GET",
            "url": f"{base_url}/",
            "expected_status": 200
        },
        {
            "name": "API Health Check",
            "method": "GET", 
            "url": f"{base_url}/api/health",
            "expected_status": 200
        },
        {
            "name": "Get Classes",
            "method": "GET",
            "url": f"{base_url}/api/classes/",
            "expected_status": 200
        },
        {
            "name": "Get Subjects",
            "method": "GET",
            "url": f"{base_url}/api/subjects/",
            "expected_status": 200
        },
        {
            "name": "Get Math Games",
            "method": "GET",
            "url": f"{base_url}/api/games/math-games",
            "expected_status": 200
        }
    ]
    
    passed_tests = 0
    failed_tests = 0
    
    for test in tests:
        try:
            if test["method"] == "GET":
                response = requests.get(test["url"], timeout=5)
            elif test["method"] == "POST":
                response = requests.post(test["url"], json=test.get("data", {}), timeout=5)
            
            if response.status_code == test["expected_status"]:
                print(f"✅ {test['name']}: PASSED ({response.status_code})")
                passed_tests += 1
            else:
                print(f"❌ {test['name']}: FAILED (Expected {test['expected_status']}, got {response.status_code})")
                failed_tests += 1
                
        except requests.exceptions.ConnectionError:
            print(f"❌ {test['name']}: FAILED (Connection error - server may not be running)")
            failed_tests += 1
        except Exception as e:
            print(f"❌ {test['name']}: FAILED ({str(e)})")
            failed_tests += 1
    
    return passed_tests, failed_tests

def test_authentication():
    """Test authentication endpoints"""
    base_url = "http://localhost:5000"
    print("🔐 Testing authentication...")
    
    # Test login with sample user
    try:
        login_data = {
            "username": "testuser",
            "password": "password123"
        }
        
        response = requests.post(f"{base_url}/api/auth/login", json=login_data, timeout=5)
        
        if response.status_code == 200:
            print("✅ Login test: PASSED")
            
            # Extract token for further tests
            token = response.json().get("data", {}).get("access_token")
            if token:
                print("✅ Token received successfully")
                
                # Test protected endpoint
                headers = {"Authorization": f"Bearer {token}"}
                profile_response = requests.get(f"{base_url}/api/auth/profile", headers=headers, timeout=5)
                
                if profile_response.status_code == 200:
                    print("✅ Protected endpoint test: PASSED")
                    return True
                else:
                    print(f"❌ Protected endpoint test: FAILED ({profile_response.status_code})")
            else:
                print("❌ Token not received in login response")
        else:
            print(f"❌ Login test: FAILED ({response.status_code})")
            if response.status_code == 401:
                print("   Make sure the database is initialized with the test user")
                
    except Exception as e:
        print(f"❌ Authentication test failed: {str(e)}")
        
    return False

def main():
    """Main setup and test function"""
    print("🎓 StudyFun Backend Setup and Test")
    print("=" * 50)
    
    # Step 1: Install requirements
    if not install_requirements():
        print("❌ Setup failed at package installation")
        return False
    
    print()
    
    # Step 2: Initialize database
    if not initialize_database():
        print("❌ Setup failed at database initialization")
        return False
    
    print()
    
    # Step 3: Start server
    server_thread = start_server()
    
    print()
    
    # Step 4: Test basic endpoints
    passed, failed = test_endpoints()
    
    print()
    
    # Step 5: Test authentication
    auth_success = test_authentication()
    
    print()
    print("=" * 50)
    print("📊 Test Results Summary")
    print(f"✅ Basic endpoint tests passed: {passed}")
    print(f"❌ Basic endpoint tests failed: {failed}")
    print(f"🔐 Authentication test: {'PASSED' if auth_success else 'FAILED'}")
    
    if passed > failed and auth_success:
        print()
        print("🎉 Backend setup and testing completed successfully!")
        print("🚀 Your StudyFun backend is ready to use!")
        print()
        print("Next steps:")
        print("1. Keep the server running with: python main.py")
        print("2. The API is available at: http://localhost:5000")
        print("3. Check API_DOCUMENTATION.md for detailed endpoint information")
        print("4. Use the sample user: testuser / password123")
        return True
    else:
        print()
        print("❌ Some tests failed. Please check the error messages above.")
        print("Make sure all dependencies are installed and the database is properly initialized.")
        return False

if __name__ == "__main__":
    success = main()
    if not success:
        sys.exit(1)
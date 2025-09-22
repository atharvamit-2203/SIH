# StudyFun Backend Health Check Guide

## Quick Health Checks

### 1. **Database Verification**
Check if your database has the correct data:

```bash
# In the backend directory
python -c "
from database import db
from models.user import User
from models.class_model import Class
from models.subject import Subject
from models.game import Game
from flask import Flask
from config.config import Config

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

with app.app_context():
    print('📊 Database Health Check')
    print('=' * 40)
    print(f'👥 Users in database: {User.query.count()}')
    print(f'🎓 Classes available: {Class.query.count()}')
    print(f'📚 Subjects available: {Subject.query.count()}')
    print(f'🎮 Games available: {Game.query.count()}')
    print()
    print('Sample users:')
    for user in User.query.all():
        print(f'  - {user.username} ({user.email})')
"
```

### 2. **API Endpoint Testing**
Test individual endpoints using curl or any REST client:

```bash
# Health check
curl http://localhost:5000/api/health

# Get all classes
curl http://localhost:5000/api/classes/

# Get all subjects
curl http://localhost:5000/api/subjects/

# Login test
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'
```

### 3. **Flutter Integration Test**
Here's a simple Flutter test to verify backend connection:

```dart
// Add this to your Flutter project to test backend connectivity
import 'package:http/http.dart' as http;
import 'dart:convert';

class BackendHealthChecker {
  static const String baseUrl = 'http://YOUR_IP:5000'; // Replace with your IP
  
  static Future<bool> checkBackendHealth() async {
    try {
      // Test basic health endpoint
      final healthResponse = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (healthResponse.statusCode != 200) {
        print('❌ Health check failed: ${healthResponse.statusCode}');
        return false;
      }
      
      // Test login with sample user
      final loginResponse = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': 'testuser',
          'password': 'password123'
        }),
      );
      
      if (loginResponse.statusCode != 200) {
        print('❌ Login test failed: ${loginResponse.statusCode}');
        return false;
      }
      
      final loginData = jsonDecode(loginResponse.body);
      final token = loginData['data']['access_token'];
      
      // Test protected endpoint
      final profileResponse = await http.get(
        Uri.parse('$baseUrl/api/auth/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (profileResponse.statusCode != 200) {
        print('❌ Protected endpoint test failed: ${profileResponse.statusCode}');
        return false;
      }
      
      print('✅ All backend tests passed!');
      return true;
      
    } catch (e) {
      print('❌ Backend connection error: $e');
      return false;
    }
  }
  
  static Future<void> runFullTest() async {
    print('🔍 Testing StudyFun Backend Connection...');
    
    final isHealthy = await checkBackendHealth();
    
    if (isHealthy) {
      print('🎉 Backend is working perfectly!');
      print('✅ Database is connected');
      print('✅ Authentication is working');
      print('✅ API endpoints are responding');
    } else {
      print('❌ Backend has issues - check the logs');
    }
  }
}

// Usage in your Flutter app:
// await BackendHealthChecker.runFullTest();
```

## Signs Your Backend is Working Properly

### ✅ **Good Signs:**
- **Registration/Login Success**: Users can register and login
- **Data Persistence**: User data is saved between sessions
- **API Responses**: All endpoints return proper JSON responses
- **Database Consistency**: User preferences, scores, and game progress are maintained
- **JWT Tokens**: Authentication tokens are generated and validated

### ❌ **Warning Signs:**
- **Empty Responses**: APIs return empty arrays or null data
- **401/403 Errors**: Authentication failures
- **500 Errors**: Server crashes or database connection issues
- **Data Loss**: User information disappears between sessions
- **Slow Response**: Endpoints take too long to respond

## Real-World Verification Steps

### 1. **User Registration Flow Test**
```bash
# Register a new user
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser2",
    "password": "password123",
    "email": "test2@example.com",
    "full_name": "Test User Two"
  }'
```

### 2. **Game Data Verification**
```bash
# Check if games are loaded
curl http://localhost:5000/api/games/math-games
```

### 3. **User Progress Tracking**
```bash
# Login and get token
TOKEN=$(curl -s -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}' \
  | python -c "import sys, json; print(json.load(sys.stdin)['data']['access_token'])")

# Check user's game progress
curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:5000/api/games/my-progress
```

## Monitoring in Production

### Log Monitoring
Check your Flask application logs for:
- Database connection errors
- Authentication failures
- API request/response patterns
- Performance bottlenecks

### Database Monitoring
```bash
# Check database file size and modification time
ls -la studyfun.db

# View recent database changes (if using timestamps)
python -c "
from database import db
from models.user import User
from flask import Flask
from config.config import Config
import datetime

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

with app.app_context():
    recent_users = User.query.order_by(User.created_at.desc()).limit(5).all()
    print('Recent user registrations:')
    for user in recent_users:
        print(f'  {user.username} - {user.created_at}')
"
```

## Flutter Frontend Integration Checklist

### ✅ **Before Integration:**
- [ ] Backend server is running on accessible IP/port
- [ ] All API endpoints respond correctly
- [ ] Database has sample data
- [ ] CORS is configured for Flutter domain
- [ ] JWT authentication works

### ✅ **During Integration:**
- [ ] Network permissions are set in Flutter
- [ ] Base URL points to correct backend
- [ ] HTTP client handles authentication headers
- [ ] Error handling for network failures
- [ ] Token storage and refresh logic

### ✅ **After Integration:**
- [ ] User can register/login from Flutter app
- [ ] Game data loads in the app
- [ ] Scores are submitted and saved
- [ ] User preferences persist
- [ ] Offline/online state is handled

## Troubleshooting Common Issues

### Database Connection Issues
```bash
# Reset database if needed
python init_db.py
```

### Port Conflicts
```bash
# Check if port 5000 is in use
netstat -an | grep :5000
```

### Authentication Problems
- Verify JWT secret keys match
- Check token expiration settings
- Ensure proper Authorization header format

### CORS Issues
- Add Flutter domain to CORS configuration
- Check browser console for CORS errors
- Verify preflight request handling

Remember: The comprehensive test that passed shows your backend is fully functional! 🚀
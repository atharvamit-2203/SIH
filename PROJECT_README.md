# 🎓 StudyFun - Educational Mobile Application

A comprehensive educational platform featuring a **Flask backend API** and **Flutter mobile frontend** designed for students from grades 6-12.

## 🌟 Features

### 🔐 **Authentication System**
- User registration and login
- JWT token-based authentication
- Secure password hashing with bcrypt
- User profile management

### 📚 **Academic Content**
- **7 Grade Levels**: 6th to 12th grade
- **6 Subjects**: Mathematics, Science, English, History, Geography, Computer Science
- **Educational Games**: Interactive math games with multiple difficulty levels
- **Progress Tracking**: Score tracking and leaderboards

### 🎮 **Gaming Features**
- **Math Games**: Addition, Subtraction, Multiplication, Division, Fractions
- **Difficulty Levels**: Beginner, Intermediate, Advanced
- **Scoring System**: Percentage-based scoring with time tracking
- **User Progress**: Track attempts and best scores

### 🎨 **User Experience**
- Theme preferences (Light/Dark mode)
- Responsive design
- Emoji-rich interface
- Real-time score updates

## 🏗️ Project Structure

```
StudyFun/
├── 📂 backend/                 # Flask API Backend
│   ├── 📂 models/             # Database models
│   ├── 📂 routes/             # API endpoints
│   ├── 📂 config/             # Configuration files
│   ├── 📄 main.py             # Flask application entry point
│   ├── 📄 init_db.py          # Database initialization
│   ├── 📄 database.py         # Centralized database instance
│   └── 📄 requirements.txt    # Python dependencies
├── 📂 frontend/               # Web Frontend (if applicable)
├── 📂 flutter_sample_frontend/# Flutter Mobile App
├── 📂 pyGame/                 # PyGame Components
├── 📄 FLUTTER_INTEGRATION_GUIDE.md
└── 📄 README.md
```

## 🚀 Quick Start

### **Backend Setup**

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Initialize the database:**
   ```bash
   python init_db.py
   ```

4. **Run the backend server:**
   ```bash
   python main.py
   ```

5. **Backend will be available at:** `http://localhost:5000`

### **Automated Setup & Testing**
```bash
cd backend
python setup_and_test.py
```

This will:
- ✅ Install all dependencies
- ✅ Initialize database with sample data  
- ✅ Start the server
- ✅ Run comprehensive API tests
- ✅ Test authentication flow

## 📱 Flutter Integration

### **Setup Flutter Dependencies**
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.0.5
  flutter_secure_storage: ^9.0.0
```

### **API Integration**
Check `FLUTTER_INTEGRATION_GUIDE.md` for:
- Complete API service class
- Authentication handling
- Model classes
- Example screens
- Network configuration

## 🗄️ Database Schema

### **Core Models:**
- **👤 Users**: Authentication and profile data
- **🎓 Classes**: Grade levels (6th-12th) 
- **📚 Subjects**: Academic subjects with emojis and colors
- **🎮 Games**: Educational games with difficulty levels
- **🏆 Scores**: User performance tracking

### **Sample Data Included:**
- **Test User**: `testuser` / `password123`
- **7 Grade Levels**: Complete grade structure
- **6 Subjects**: All major academic subjects
- **5 Math Games**: Ready-to-play educational games

## 🔗 API Endpoints

### **Authentication**
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login  
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile

### **Academic Content**
- `GET /api/classes/` - Get all grade levels
- `GET /api/subjects/` - Get all subjects
- `GET /api/subjects/my-subjects` - Get subjects for user's grade

### **Games & Scoring**
- `GET /api/games/math-games` - Get math games
- `GET /api/games/my-progress` - Get user's game progress
- `POST /api/scores/` - Submit game score
- `GET /api/scores/leaderboard` - Get leaderboards

## 🧪 Testing & Health Checks

### **Backend Health Check**
```bash
python check_database.py
```

### **API Testing**
```bash
# Health check
curl http://localhost:5000/api/health

# Test login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username": "testuser", "password": "password123"}'
```

### **Comprehensive Testing**
The backend includes automated testing that verifies:
- ✅ Database connectivity
- ✅ All API endpoints
- ✅ Authentication flow
- ✅ Data relationships
- ✅ Sample data integrity

## 🛠️ Technology Stack

### **Backend**
- **Framework**: Flask 2.3.3
- **Database**: SQLAlchemy with SQLite
- **Authentication**: JWT tokens with Flask-JWT-Extended
- **Security**: bcrypt password hashing, CORS protection
- **API**: RESTful JSON APIs

### **Frontend**
- **Mobile**: Flutter (Dart)
- **State Management**: Provider pattern
- **Storage**: Secure storage for tokens
- **HTTP Client**: http package

### **Database**
- **ORM**: SQLAlchemy
- **Database**: SQLite (development), scalable to PostgreSQL
- **Relationships**: Proper foreign keys and relationships

## 📊 Backend Status

```
📊 StudyFun Database Health Check
============================================================
✅ EXCELLENT: All core data is present!
✅ Backend is fully functional  
✅ Database is properly initialized

👥 Users in database: 1+
🎓 Classes available: 7  
📚 Subjects available: 6
🎮 Games available: 5
🏆 Scores recorded: Ready for tracking
```

## 🔧 Configuration

### **Environment Variables**
```bash
DATABASE_URL=sqlite:///studyfun.db
JWT_SECRET_KEY=your-secret-key-here
SECRET_KEY=your-flask-secret-key-here
```

### **Development vs Production**
- **Development**: SQLite, Debug mode enabled
- **Production**: PostgreSQL recommended, Gunicorn deployment

## 📈 Future Enhancements

- [ ] More game types (Science, English, etc.)
- [ ] Real-time multiplayer games  
- [ ] Teacher dashboard
- [ ] Progress analytics
- [ ] Offline mode support
- [ ] Push notifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Update documentation
5. Submit a pull request

## 📄 License

This project is developed for educational purposes as part of SIH (Smart India Hackathon).

## 🎯 Project Goals

**StudyFun** aims to make learning engaging and interactive for students across different grade levels, providing a gamified approach to education with proper progress tracking and performance analytics.

---

## 🚀 **Ready for Development!**

Your StudyFun backend is fully functional and ready for Flutter integration. The comprehensive test suite ensures reliability and the modular architecture supports easy expansion.

**Happy Coding! 🎉**
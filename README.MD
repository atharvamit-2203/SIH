# 🎮 StudyFun - Educational Gaming Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue.svg)](https://flutter.dev)
[![Python](https://img.shields.io/badge/Python-3.11-green.svg)](https://python.org)
[![Flask](https://img.shields.io/badge/Flask-3.0-red.svg)](https://flask.palletsprojects.com)
[![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0-orange.svg)](https://sqlalchemy.org)

> **A comprehensive educational gaming platform that combines interactive learning with engaging gameplay mechanics. Built for students to learn through fun and interactive experiences.**

## 📚 Table of Contents

- [🌟 Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🚀 Quick Start](#-quick-start)
- [📱 Frontend (Flutter)](#-frontend-flutter)
- [🔧 Backend (Flask)](#-backend-flask)
- [🎮 Game Integration](#-game-integration)
- [🔐 Authentication System](#-authentication-system)
- [📊 Database Schema](#-database-schema)
- [🌐 API Documentation](#-api-documentation)
- [🛠️ Development Setup](#️-development-setup)
- [🧪 Testing](#-testing)
- [📝 Contributing](#-contributing)
- [📄 License](#-license)

## 🌟 Features

### 📱 **Mobile Application (Flutter)**
- **Modern UI/UX Design** - Beautiful interface with light/dark mode support
- **Real-time Authentication** - Secure login system with JWT tokens
- **User Profile Management** - Complete user profile with class selection
- **Game Integration Hub** - Launch and track PyGame desktop games
- **Progress Tracking** - Monitor learning progress and scores
- **Responsive Design** - Works on phones, tablets, and web browsers

### 🔧 **Backend API (Flask)**
- **RESTful API Architecture** - Clean, scalable API endpoints
- **JWT Authentication** - Secure token-based authentication
- **User Management System** - Complete CRUD operations for users
- **Score Tracking** - Game score storage and analytics
- **Class Management** - Support for different educational classes
- **Database Integration** - SQLAlchemy ORM with SQLite/PostgreSQL support

### 🎮 **Game Integration**
- **PyGame Desktop Games** - Standalone educational games
- **API Communication** - Games connect to backend for user authentication
- **Score Submission** - Automatic score tracking and leaderboards
- **Session Management** - User sessions across games and mobile app
- **Progress Synchronization** - Real-time progress updates

## 🏗️ Architecture

```
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│                     │    │                     │    │                     │
│   Flutter Mobile    │◄──►│   Flask Backend     │◄──►│   PyGame Desktop    │
│      Frontend       │    │       API           │    │       Games         │
│                     │    │                     │    │                     │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
         │                           │                           │
         │                           │                           │
         ▼                           ▼                           ▼
┌─────────────────────┐    ┌─────────────────────┐    ┌─────────────────────┐
│                     │    │                     │    │                     │
│   User Interface    │    │   SQLite Database   │    │   Game Assets &     │
│   Components        │    │   (SQLAlchemy ORM)  │    │   Logic             │
│                     │    │                     │    │                     │
└─────────────────────┘    └─────────────────────┘    └─────────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK** (3.35.4+)
- **Python** (3.11+)
- **Git**
- **Android Studio** (for mobile development)
- **VS Code** (recommended)

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/SIH.git
cd SIH
```

### 2. Backend Setup
```bash
cd backend

# Install Python dependencies
pip install -r requirements.txt

# Create demo users
python create_demo_users.py

# Start the Flask server
python main.py
```
✅ Backend will be running on `http://localhost:5000`

### 3. Frontend Setup
```bash
cd ../flutter_sample_frontend

# Install Flutter dependencies
flutter pub get

# Run on web browser
flutter run -d chrome

# Or run on Android device
flutter run -d [device-id]
```

### 4. Test the Application
- **Open your browser** to the Flutter app
- **Login with demo accounts:**
  - `demo` / `demo123`
  - `guest` / `guest123`
  - `student` / `student123`
  - `test` / `test123`

## 📱 Frontend (Flutter)

### 🎨 **UI Components**
- **Welcome Screen** - Animated landing page with floating elements
- **Login Page** - Enhanced authentication with real-time validation
- **Registration** - User signup with form validation
- **Class Selection** - Choose educational class/grade level
- **Profile Management** - Update user information and preferences

### 🔧 **Technical Features**
- **State Management** - Provider pattern for reactive UI
- **HTTP Client** - RESTful API communication with error handling
- **Local Storage** - Secure token storage with SharedPreferences
- **Animations** - Smooth transitions and micro-interactions
- **Responsive Design** - Adaptive layouts for different screen sizes

### 📂 **Project Structure**
```
flutter_sample_frontend/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── login.dart               # Login page with backend integration
│   ├── signup.dart              # User registration
│   ├── class_page.dart          # Class selection interface
│   ├── services/
│   │   └── auth_service.dart    # Authentication API client
│   └── widgets/                 # Reusable UI components
├── android/                     # Android-specific configuration
├── web/                         # Web deployment files
└── pubspec.yaml                 # Flutter dependencies
```

## 🔧 Backend (Flask)

### 🌐 **API Endpoints**

#### 🔐 **Authentication**
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User authentication
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile
- `POST /api/auth/refresh` - Refresh JWT token

#### 👥 **User Management**
- `GET /api/users` - List all users (admin)
- `GET /api/users/{id}` - Get specific user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

#### 🏫 **Classes**
- `GET /api/classes` - List all classes
- `POST /api/classes` - Create new class
- `GET /api/classes/{id}` - Get class details
- `PUT /api/classes/{id}` - Update class
- `DELETE /api/classes/{id}` - Delete class

#### 🎮 **Games & Scores**
- `POST /api/scores` - Submit game score
- `GET /api/scores/user/{id}` - Get user scores
- `GET /api/games` - List available games
- `POST /api/games` - Register new game

### 🗄️ **Database Models**
```python
# User Model
class User:
    id: Integer (Primary Key)
    username: String (Unique)
    email: String (Unique)
    password_hash: String
    full_name: String
    selected_class_id: Integer (Foreign Key)
    theme_preference: String
    is_active: Boolean
    created_at: DateTime

# Score Model  
class Score:
    id: Integer (Primary Key)
    user_id: Integer (Foreign Key)
    game_id: Integer (Foreign Key)
    score: Integer
    level_completed: Integer
    time_spent: Integer
    created_at: DateTime

# Class Model
class Class:
    id: Integer (Primary Key)
    name: String
    description: String
    grade_level: String
    is_active: Boolean
```

### 📂 **Backend Structure**
```
backend/
├── main.py                      # Flask application entry point
├── database.py                  # Database configuration
├── requirements.txt             # Python dependencies
├── create_demo_users.py         # Demo user creation script
├── config/
│   └── config.py               # App configuration
├── models/                     # SQLAlchemy models
│   ├── user.py
│   ├── class_model.py
│   ├── score.py
│   └── game.py
├── routes/                     # API route handlers
│   ├── auth_routes.py
│   ├── class_routes.py
│   ├── score_routes.py
│   └── game_routes.py
└── instance/
    └── database.db            # SQLite database file
```

## 🎮 Game Integration

### 🐍 **PyGame Desktop Games**
The platform includes Python desktop games that integrate with the backend:

#### 📁 **Game Files**
- `game_api_client.py` - API client for games
- `game_integration.py` - Easy integration wrapper
- `SIHGame1_integrated.py` - Example integrated game

#### 🔗 **Integration Features**
- **User Authentication** - Games can authenticate users via API
- **Score Submission** - Automatic score tracking to backend
- **Session Management** - Maintain user sessions across apps
- **Progress Tracking** - Real-time progress synchronization

#### 🎯 **Example Integration**
```python
from game_integration import GameIntegration

# Initialize game with backend connection
game = GameIntegration("My Educational Game")

# Authenticate user
user = game.authenticate_user()

# Start game session
session_id = game.start_game_session()

# Submit final score
game.submit_score(final_score, level_completed, time_spent)
```

## 🔐 Authentication System

### 🔑 **JWT Token-Based Authentication**
- **Access Tokens** - Short-lived tokens for API access (15 minutes)
- **Refresh Tokens** - Long-lived tokens for token renewal (30 days)
- **Secure Storage** - Tokens stored locally with encryption
- **Automatic Refresh** - Seamless token renewal in background

### 🛡️ **Security Features**
- **Password Hashing** - Werkzeug PBKDF2 hashing
- **CORS Protection** - Cross-origin request security
- **Input Validation** - Comprehensive request validation
- **SQL Injection Prevention** - SQLAlchemy ORM protection
- **Rate Limiting** - API request throttling (configurable)

### 👤 **Demo Accounts**
Ready-to-use test accounts for development:
- **demo** / demo123
- **guest** / guest123
- **student** / student123
- **test** / test123

## 📊 Database Schema

### 🗂️ **Entity Relationship Diagram**
```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│     Users       │         │     Classes     │         │     Scores      │
├─────────────────┤         ├─────────────────┤         ├─────────────────┤
│ id (PK)         │◄────────┤ id (PK)         │         │ id (PK)         │
│ username        │         │ name            │         │ user_id (FK)    │──┐
│ email           │         │ description     │         │ game_id (FK)    │  │
│ password_hash   │         │ grade_level     │         │ score           │  │
│ full_name       │         │ is_active       │         │ level_completed │  │
│ selected_class  │─────────┤                 │         │ time_spent      │  │
│ theme_preference│         │                 │         │ created_at      │  │
│ is_active       │         │                 │         │                 │  │
│ created_at      │         │                 │         │                 │  │
└─────────────────┘         └─────────────────┘         └─────────────────┘  │
                                                                              │
┌─────────────────┐                                                          │
│     Games       │                                                          │
├─────────────────┤                                                          │
│ id (PK)         │◄─────────────────────────────────────────────────────────┘
│ name            │
│ description     │
│ version         │
│ is_active       │
│ created_at      │
└─────────────────┘
```

## 🌐 API Documentation

### 📝 **Request/Response Examples**

#### Login Request
```json
POST /api/auth/login
{
  "username": "demo",
  "password": "demo123"
}
```

#### Login Response
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 2,
      "username": "demo",
      "email": "demo@studyfun.app",
      "full_name": "Demo User"
    },
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### Score Submission
```json
POST /api/scores
Authorization: Bearer {access_token}
{
  "game_id": 1,
  "score": 850,
  "level_completed": 5,
  "time_spent": 120
}
```

## 🛠️ Development Setup

### 🔄 **Development Workflow**

#### 1. Backend Development
```bash
cd backend

# Install dependencies in virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Run in development mode
export FLASK_ENV=development
python main.py
```

#### 2. Frontend Development
```bash
cd flutter_sample_frontend

# Hot reload for development
flutter run -d chrome --hot

# Build for production
flutter build web
```

#### 3. Game Development
```bash
cd games

# Test game integration
python SIHGame1_integrated.py

# Create new integrated game
python game_template.py
```

### 🐛 **Debugging Tips**

#### Backend Issues
- Check Flask logs in terminal
- Verify database connection: `python -c "from database import db; print('DB OK')"`
- Test API endpoints with Postman or curl
- Enable debug mode: `app.run(debug=True)`

#### Frontend Issues
- Use Flutter Inspector in VS Code
- Check browser developer tools for network errors
- Verify API base URL in `auth_service.dart`
- Test on multiple devices/browsers

#### Game Integration Issues
- Verify backend server is running on correct port
- Check network connectivity between game and API
- Review authentication token format
- Test API endpoints independently

## 🧪 Testing

### 🔬 **Automated Testing**

#### Backend Tests
```bash
cd backend
python -m pytest tests/ -v
```

#### Frontend Tests
```bash
cd flutter_sample_frontend
flutter test
```

### 📋 **Manual Testing Checklist**

#### ✅ **Authentication Flow**
- [ ] User registration with validation
- [ ] Login with correct credentials
- [ ] Login failure with wrong credentials
- [ ] Token refresh functionality
- [ ] Logout and session cleanup

#### ✅ **UI/UX Testing**
- [ ] Responsive design on different screen sizes
- [ ] Light/dark mode switching
- [ ] Animation smoothness
- [ ] Loading states and error handling
- [ ] Navigation flow

#### ✅ **Game Integration**
- [ ] Game launches successfully
- [ ] User authentication in game
- [ ] Score submission to backend
- [ ] Progress synchronization
- [ ] Session management

## 📈 **Performance Optimization**

### 🚀 **Frontend Optimizations**
- **Lazy Loading** - Load screens on demand
- **Image Optimization** - Compressed assets and caching
- **State Management** - Efficient Provider usage
- **Bundle Optimization** - Tree shaking and code splitting

### ⚡ **Backend Optimizations**
- **Database Indexing** - Optimized queries
- **Connection Pooling** - Efficient database connections
- **Caching Layer** - Redis for frequently accessed data
- **API Rate Limiting** - Prevent abuse and ensure stability

## 🚀 **Deployment**

### 🌐 **Production Deployment**

#### Backend (Flask)
```bash
# Using Gunicorn
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 main:app

# Using Docker
docker build -t studyfun-backend .
docker run -p 5000:5000 studyfun-backend
```

#### Frontend (Flutter Web)
```bash
flutter build web
# Deploy to Firebase Hosting, Netlify, or Vercel
```

#### Environment Variables
```bash
# .env file
SECRET_KEY=your-secret-key-here
DATABASE_URL=sqlite:///instance/database.db
JWT_SECRET_KEY=your-jwt-secret-here
FLASK_ENV=production
```

## 📝 Contributing

### 🤝 **How to Contribute**

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
6. **Push to your fork**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### 📋 **Development Guidelines**

#### Code Style
- **Python**: Follow PEP 8 standards
- **Dart/Flutter**: Use `flutter format` and follow Effective Dart
- **Comments**: Clear, concise documentation
- **Commit Messages**: Descriptive and meaningful

#### Testing Requirements
- Unit tests for new functions
- Integration tests for API endpoints
- UI tests for new Flutter components
- Game integration tests

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎯 **Project Status**

### ✅ **Completed Features**
- [x] Flutter mobile app with modern UI
- [x] Flask backend API with authentication
- [x] JWT token-based security system
- [x] SQLAlchemy database integration
- [x] PyGame desktop game integration
- [x] User management and profiles
- [x] Score tracking and analytics
- [x] Real-time authentication validation
- [x] Cross-platform compatibility

### 🚧 **In Progress**
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Push notifications
- [ ] Social features (friends, leaderboards)
- [ ] Advanced game achievements system

### 🎯 **Future Roadmap**
- [ ] Machine learning-based personalized learning
- [ ] Voice-controlled game interactions
- [ ] Augmented Reality (AR) educational games
- [ ] Progressive Web App (PWA) support
- [ ] Advanced accessibility features

---

## 🆘 **Support & Help**

### 📞 **Getting Help**
- **Documentation**: Check this README and API docs
- **Issues**: Create GitHub issues for bugs
- **Discussions**: Use GitHub Discussions for questions
- **Email**: Contact the development team

### 🔧 **Troubleshooting**

#### Common Issues
1. **Backend won't start**: Check Python version and dependencies
2. **Flutter build fails**: Run `flutter clean && flutter pub get`
3. **Authentication fails**: Verify API endpoints and tokens
4. **Database errors**: Check SQLite file permissions
5. **Game integration issues**: Ensure backend is running

---

## 👥 **Team**

### 🧑‍💻 **Development Team**
- **Frontend Development**: Flutter/Dart specialists
- **Backend Development**: Python/Flask experts
- **Game Development**: PyGame developers
- **UI/UX Design**: User experience designers
- **DevOps**: Deployment and infrastructure

---

## 🙏 **Acknowledgments**

- **Flutter Team** for the amazing cross-platform framework
- **Flask Community** for the lightweight web framework
- **PyGame Community** for educational game development tools
- **Open Source Contributors** for various packages and libraries

---

<div align="center">

### 🌟 **Star this repository if you found it helpful!**

**Built with ❤️ for education and learning**

[⬆ Back to Top](#-studyfun---educational-gaming-platform)

</div>

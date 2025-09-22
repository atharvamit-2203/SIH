# StudyFun Backend

A Flask-based backend API for the StudyFun educational mobile application. This backend provides user authentication, class/subject management, game data, and scoring system functionality.

## Features

- 🔐 **User Authentication** - Registration, login, JWT tokens
- 📚 **Class Management** - Grade levels from 6th to 12th
- 📖 **Subject System** - Math, Science, English, History, Geography, Computer Science
- 🎮 **Games API** - Educational games with difficulty levels
- 📊 **Scoring System** - User progress tracking and leaderboards
- 🏆 **User Statistics** - Comprehensive performance analytics
- 🌙 **Theme Support** - Light/Dark mode preferences
- 📱 **Flutter Integration** - Designed specifically for Flutter frontend

## Quick Start

### Option 1: Automated Setup (Recommended)
```bash
cd backend
python setup_and_test.py
```

### Option 2: Manual Setup
```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Initialize database
python init_db.py

# Run the server
python main.py
```

The server will be available at `http://localhost:5000`

## Project Structure

```
backend/
├── main.py                 # Flask application entry point
├── init_db.py             # Database initialization script
├── setup_and_test.py      # Automated setup and testing
├── requirements.txt       # Python dependencies
├── API_DOCUMENTATION.md   # Complete API documentation
├── README.md             # This file
├── config/
│   ├── __init__.py
│   └── config.py         # Application configuration
├── models/               # Database models
│   ├── __init__.py
│   ├── user.py          # User model
│   ├── class_model.py   # Class/Grade model
│   ├── subject.py       # Subject model
│   ├── game.py          # Game model
│   └── score.py         # Score model
└── routes/              # API route handlers
    ├── __init__.py
    ├── auth_routes.py   # Authentication endpoints
    ├── class_routes.py  # Class management endpoints
    ├── subject_routes.py# Subject endpoints
    ├── game_routes.py   # Game endpoints
    └── score_routes.py  # Scoring endpoints
```

## Database Schema

The backend uses SQLite with the following models:

- **User** - Authentication and profile data
- **Class** - Grade levels (6th-12th)
- **Subject** - Academic subjects with emojis and colors
- **Game** - Educational games with difficulty levels
- **Score** - User performance tracking

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile
- `POST /api/auth/refresh` - Refresh JWT token

### Classes
- `GET /api/classes/` - Get all grade levels
- `GET /api/classes/{id}` - Get specific grade
- `POST /api/classes/select` - Select user's grade
- `GET /api/classes/my-class` - Get user's selected grade

### Subjects
- `GET /api/subjects/` - Get all subjects
- `GET /api/subjects/{id}` - Get specific subject
- `GET /api/subjects/my-subjects` - Get subjects for user's grade
- `GET /api/subjects/by-class/{class_id}` - Get subjects by grade

### Games
- `GET /api/games/` - Get all games
- `GET /api/games/{id}` - Get specific game
- `GET /api/games/by-subject/{subject_id}` - Get games by subject
- `GET /api/games/math-games` - Get math games specifically
- `GET /api/games/my-progress` - Get user's game progress
- `POST /api/games/start/{game_id}` - Start a game session

### Scores
- `POST /api/scores/` - Submit game score
- `GET /api/scores/my-scores` - Get user's scores
- `GET /api/scores/leaderboard` - Get game leaderboards
- `GET /api/scores/stats` - Get user statistics
- `GET /api/scores/{id}` - Get specific score

## Sample Data

The backend comes pre-loaded with:

### Classes (Grade Levels)
- 6th Grade through 12th Grade

### Subjects
- 📊 **Maths** - Mathematics and problem solving
- 🔬 **Science** - Scientific concepts and experiments
- 📚 **English** - Language arts and literature
- 🏰 **History** - Historical events and civilizations
- 🌍 **Geography** - World geography and cultures
- 💻 **Comp Sci** - Computer science and programming

### Math Games
- ➕ **Addition Adventure** (Beginner)
- ➖ **Subtraction Sprint** (Beginner)
- ✖️ **Multiplication Mayhem** (Intermediate)
- ➗ **Division Dash** (Intermediate)
- 1️⃣/2️⃣ **Fraction Frenzy** (Advanced)

### Test User
- **Username:** `testuser`
- **Password:** `password123`
- **Email:** `test@studyfun.com`
- **Class:** 8th Grade

## Flutter Integration

### Example API Calls
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Login
Future<Map<String, dynamic>> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/api/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );
  return jsonDecode(response.body);
}

// Get Classes
Future<Map<String, dynamic>> getClasses() async {
  final response = await http.get(
    Uri.parse('http://localhost:5000/api/classes/'),
    headers: {'Content-Type': 'application/json'},
  );
  return jsonDecode(response.body);
}

// Get Math Games
Future<Map<String, dynamic>> getMathGames() async {
  final response = await http.get(
    Uri.parse('http://localhost:5000/api/games/math-games'),
    headers: {'Content-Type': 'application/json'},
  );
  return jsonDecode(response.body);
}
```

## Configuration

The backend uses environment variables for configuration. You can create a `.env` file:

```env
DATABASE_URL=sqlite:///studyfun.db
JWT_SECRET_KEY=your-secret-key-here
SECRET_KEY=your-flask-secret-key-here
```

## Development

### Adding New Games
1. Add game data to `init_db.py`
2. Run `python init_db.py` to update the database

### Adding New Subjects
1. Add subject data to `init_db.py` 
2. Update the Flutter frontend to handle new subjects

### Extending the API
1. Add new routes to the appropriate route file
2. Update models if needed
3. Update `API_DOCUMENTATION.md`

## Testing

The backend includes comprehensive testing:

```bash
python setup_and_test.py
```

This will:
- Install dependencies
- Initialize the database
- Start the server
- Test all major endpoints
- Test authentication flow

## Deployment

For production deployment:

1. Use a production WSGI server like Gunicorn
2. Configure environment variables
3. Use a production database (PostgreSQL recommended)
4. Set up proper logging
5. Configure CORS for your domain

```bash
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 main:app
```

## Security Features

- JWT token-based authentication
- Password hashing with bcrypt
- CORS protection
- Input validation
- SQL injection prevention with SQLAlchemy ORM

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Update documentation
5. Submit a pull request

## License

This project is part of the StudyFun educational application.

## Support

For questions or issues:
1. Check `API_DOCUMENTATION.md` for endpoint details
2. Run `python setup_and_test.py` to diagnose issues
3. Ensure all dependencies are installed correctly
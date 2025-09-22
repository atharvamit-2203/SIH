# StudyFun Backend API Documentation

## Overview
The StudyFun Backend API provides endpoints for user authentication, class/subject management, games, and scoring system for the StudyFun educational app.

**Base URL:** `http://localhost:5000`

## Authentication
Most endpoints require JWT authentication. Include the access token in the Authorization header:
```
Authorization: Bearer <access_token>
```

## API Endpoints

### Health Check
- **GET** `/` - Backend status
- **GET** `/api/health` - Health check endpoint

### Authentication (`/api/auth`)

#### Register User
- **POST** `/api/auth/register`
- **Body:**
```json
{
  "username": "string (required)",
  "password": "string (required)",
  "email": "string (optional)",
  "full_name": "string (optional)"
}
```
- **Response:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": { ... },
    "access_token": "string",
    "refresh_token": "string"
  }
}
```

#### Login
- **POST** `/api/auth/login`
- **Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

#### Get Profile
- **GET** `/api/auth/profile`
- **Headers:** `Authorization: Bearer <token>`

#### Update Profile
- **PUT** `/api/auth/profile`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
```json
{
  "email": "string (optional)",
  "full_name": "string (optional)",
  "selected_class_id": "integer (optional)",
  "theme_preference": "light|dark (optional)"
}
```

#### Refresh Token
- **POST** `/api/auth/refresh`
- **Headers:** `Authorization: Bearer <refresh_token>`

### Classes (`/api/classes`)

#### Get All Classes
- **GET** `/api/classes/`
- **Response:**
```json
{
  "success": true,
  "data": {
    "classes": [
      {
        "id": 1,
        "name": "6th Grade",
        "grade_level": 6,
        "description": "Elementary to Middle School transition",
        "is_active": true,
        "created_at": "2023-..."
      }
    ],
    "count": 7
  }
}
```

#### Get Specific Class
- **GET** `/api/classes/{class_id}`

#### Select Class (User)
- **POST** `/api/classes/select`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
```json
{
  "class_id": 1
}
```

#### Get My Class
- **GET** `/api/classes/my-class`
- **Headers:** `Authorization: Bearer <token>`

### Subjects (`/api/subjects`)

#### Get All Subjects
- **GET** `/api/subjects/`
- **Query Params:**
  - `class_id` (optional): Filter by class

#### Get Specific Subject
- **GET** `/api/subjects/{subject_id}`

#### Get My Subjects
- **GET** `/api/subjects/my-subjects`
- **Headers:** `Authorization: Bearer <token>`

#### Get Subjects by Class
- **GET** `/api/subjects/by-class/{class_id}`

### Games (`/api/games`)

#### Get All Games
- **GET** `/api/games/`
- **Query Params:**
  - `subject_id` (optional): Filter by subject
  - `difficulty` (optional): Filter by difficulty level

#### Get Specific Game
- **GET** `/api/games/{game_id}`

#### Get Games by Subject
- **GET** `/api/games/by-subject/{subject_id}`

#### Get Math Games
- **GET** `/api/games/math-games`

#### Get My Game Progress
- **GET** `/api/games/my-progress`
- **Headers:** `Authorization: Bearer <token>`

#### Start Game
- **POST** `/api/games/start/{game_id}`
- **Headers:** `Authorization: Bearer <token>`

### Scores (`/api/scores`)

#### Submit Score
- **POST** `/api/scores/`
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
```json
{
  "game_id": 1,
  "score": 85,
  "time_taken": 120,
  "is_completed": true
}
```

#### Get My Scores
- **GET** `/api/scores/my-scores`
- **Headers:** `Authorization: Bearer <token>`
- **Query Params:**
  - `game_id` (optional): Filter by game
  - `limit` (optional, default=50): Limit results

#### Get Leaderboard
- **GET** `/api/scores/leaderboard`
- **Query Params:**
  - `game_id` (optional): Specific game leaderboard
  - `limit` (optional, default=10): Number of results

#### Get User Stats
- **GET** `/api/scores/stats`
- **Headers:** `Authorization: Bearer <token>`

#### Get Specific Score
- **GET** `/api/scores/{score_id}`
- **Headers:** `Authorization: Bearer <token>`

## Sample Data

### Default Classes
1. 6th Grade (grade_level: 6)
2. 7th Grade (grade_level: 7)
3. 8th Grade (grade_level: 8)
4. 9th Grade (grade_level: 9)
5. 10th Grade (grade_level: 10)
6. 11th Grade (grade_level: 11)
7. 12th Grade (grade_level: 12)

### Default Subjects
1. Maths (➗) - Mathematics and problem solving
2. Science (🔬) - Scientific concepts and experiments
3. English (📚) - Language arts and literature
4. History (🏰) - Historical events and civilizations
5. Geography (🌍) - World geography and cultures
6. Comp Sci (💻) - Computer science and programming

### Default Math Games
1. Addition Adventure (➕) - Beginner level, 100 max score
2. Subtraction Sprint (➖) - Beginner level, 100 max score
3. Multiplication Mayhem (✖️) - Intermediate level, 150 max score
4. Division Dash (➗) - Intermediate level, 150 max score
5. Fraction Frenzy (1️⃣/2️⃣) - Advanced level, 200 max score

## Error Responses

All endpoints return consistent error responses:
```json
{
  "success": false,
  "message": "Error description"
}
```

### Common HTTP Status Codes
- **200** - Success
- **201** - Created
- **400** - Bad Request
- **401** - Unauthorized
- **404** - Not Found
- **409** - Conflict
- **500** - Internal Server Error

## Setup Instructions

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Initialize the database:
```bash
python init_db.py
```

3. Run the server:
```bash
python main.py
```

The server will run on `http://localhost:5000`

## Sample User for Testing
- **Username:** `testuser`
- **Password:** `password123`
- **Class:** 8th Grade
- **Email:** `test@studyfun.com`

## Flutter Integration

### Example API Call from Flutter:
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:5000/api/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );
  
  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getClasses() async {
  final response = await http.get(
    Uri.parse('http://localhost:5000/api/classes/'),
    headers: {'Content-Type': 'application/json'},
  );
  
  return jsonDecode(response.body);
}

Future<Map<String, dynamic>> getMathGames() async {
  final response = await http.get(
    Uri.parse('http://localhost:5000/api/games/math-games'),
    headers: {'Content-Type': 'application/json'},
  );
  
  return jsonDecode(response.body);
}
```

This API provides all the backend functionality needed for the StudyFun Flutter application, including user management, class/subject organization, game data, and progress tracking.
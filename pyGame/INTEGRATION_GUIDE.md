# 🎮 StudyFun PyGame Integration Guide

This guide explains how to integrate your existing PyGame educational games with the StudyFun backend API, enabling seamless communication between your games and the Flutter mobile app.

## 🌟 Features

### ✅ **What the Integration Provides:**
- **🔐 User Authentication** - Games can authenticate users through the backend
- **📊 Score Submission** - Automatic score tracking and submission to database
- **🏆 Progress Tracking** - User progress is saved and synchronized
- **📱 Flutter Communication** - Games communicate with Flutter app via backend API
- **🌐 Online/Offline Mode** - Games work both online and offline
- **🎯 Leaderboards** - Automatic leaderboard integration
- **👤 User Management** - User profiles and preferences

## 🚀 Quick Start Integration

### **Step 1: Install Dependencies**
```bash
pip install -r requirements.txt
```

### **Step 2: Basic Integration (3 Lines of Code!)**
```python
# Add these imports to your existing game
from game_integration import setup_studyfun_integration

# At the start of your game
integration = setup_studyfun_integration("YourGameName", screen, font)

# At game over
integration.show_game_over_screen(screen, font, final_score, max_score, time_taken)
```

### **Step 3: Start Backend**
```bash
cd ../backend
python main.py
```

## 📋 Integration Methods

### **Method 1: Super Simple Integration**
```python
from game_integration import setup_studyfun_integration

def your_game():
    # Your existing game setup
    screen = pygame.display.set_mode((800, 600))
    font = pygame.font.SysFont("arial", 24)
    
    # Add StudyFun integration (shows login screen automatically)
    integration = setup_studyfun_integration("SIHGame1", screen, font)
    
    # Your game loop...
    
    # When game ends:
    if integration.show_game_over_screen(screen, font, score, 100, time_taken):
        # User wants to restart
        restart_game()
    else:
        # User wants to quit
        quit_game()
```

### **Method 2: Advanced Integration**
```python
from game_integration import StudyFunGameIntegration

class MyGame:
    def __init__(self):
        self.integration = StudyFunGameIntegration("SIHGame1")
        
    def start_game(self):
        # Check if user wants to login
        if self.integration.show_login_screen(screen, font):
            self.integration.start_game_session()
            print(f"Playing as: {self.integration.get_user_info()['username']}")
        
        self.run_game_loop()
    
    def game_over(self, score, max_score, time_taken):
        # Submit score automatically
        result = self.integration.submit_score(score, max_score, time_taken)
        
        if result['success']:
            print(f"Score submitted! Percentage: {result['score_data']['percentage']}%")
        
        # Show game over screen
        return self.integration.show_game_over_screen(screen, font, score, max_score, time_taken)
```

## 🎯 Game Mapping

Your PyGame names are automatically mapped to backend games:

| PyGame File | Backend Game | Subject |
|-------------|--------------|---------|
| `SIHGame1.py` | Fraction Frenzy | Math |
| `SIHGame4.py` | Addition Adventure | Math |
| `SIHGame5.py` | Multiplication Mayhem | Math |
| `SIHGame6.py` | Division Dash | Math |

## 🔧 Configuration Options

### **Backend URL Configuration**
```python
# For local development (default)
integration = StudyFunGameIntegration("SIHGame1", "http://localhost:5000")

# For production deployment
integration = StudyFunGameIntegration("SIHGame1", "https://your-backend.com")
```

### **Custom Game Mapping**
Edit `game_api_client.py` to add your custom games:
```python
game_mapping = {
    "your_custom_game": "Custom Math Game",
    "another_game": "Another Game Name"
}
```

## 🎮 Login System

### **User Authentication**
The integration provides a beautiful login screen with:
- Username and password fields
- Test user quick login (F1 key)
- Offline mode option (ESC key)
- Tab navigation between fields
- Visual feedback and error messages

### **Test User Credentials**
- **Username:** `testuser`
- **Password:** `password123`
- **Quick Access:** Press F1 in login screen

## 📊 Score Submission

### **Automatic Score Tracking**
```python
# When game ends, call:
integration.submit_score(
    score=85,           # Player's score
    max_score=100,      # Maximum possible score  
    time_taken=120      # Time in seconds (optional)
)
```

### **Score Data Includes:**
- Player's raw score
- Percentage calculation
- Time taken to complete
- Number of attempts
- Timestamp of completion

## 🏆 User Progress Features

### **What Gets Tracked:**
- ✅ **Best Scores** - Highest score per game
- ✅ **Total Attempts** - Number of times played
- ✅ **Time Records** - Best completion times  
- ✅ **Progress History** - Complete play history
- ✅ **Achievements** - Based on performance
- ✅ **Leaderboard Rankings** - Compare with other players

## 📱 Flutter App Communication

### **Data Flow:**
```
PyGame ←→ Backend API ←→ Flutter App

1. PyGame authenticates user via Backend
2. PyGame submits scores to Backend
3. Flutter app fetches user progress from Backend  
4. Leaderboards update in real-time
5. User profiles sync across all platforms
```

## 🔌 API Integration Details

### **Available API Functions:**
```python
# User authentication
integration.authenticate_user(username, password)

# Game session management  
integration.start_game_session(game_id)

# Score submission
integration.submit_game_score(game_id, score, max_score, time_taken)

# User progress
integration.get_user_progress()

# Leaderboards
integration.get_leaderboard(game_id, limit=10)

# Connection status
integration.check_backend_connection()
```

## 🎨 UI Integration

### **Login Screen Features:**
- Clean, modern design matching StudyFun theme
- Keyboard navigation (TAB, ENTER, ESC)
- Real-time authentication feedback
- Test user quick access
- Offline mode option

### **Game Over Screen Features:**
- Score display with percentage
- Time taken information
- Online score submission status
- Restart/quit options
- Visual feedback for successful submission

## 🛠️ Development Workflow

### **1. Develop Your Game**
Create your PyGame as usual with your educational content.

### **2. Add Integration**  
Add just a few lines to enable StudyFun integration:
```python
from game_integration import setup_studyfun_integration

# At game start
integration = setup_studyfun_integration("YourGameName", screen, font)

# At game end  
integration.show_game_over_screen(screen, font, score, max_score, time_taken)
```

### **3. Test Integration**
```bash
# Start backend
cd backend && python main.py

# Run your integrated game
cd pyGame && python your_integrated_game.py
```

### **4. Flutter App Updates**
Your scores automatically appear in the Flutter app through the backend API!

## 📁 File Structure
```
pyGame/
├── game_api_client.py          # Core API client
├── game_integration.py         # Easy integration wrapper
├── SIHGame1_integrated.py      # Example integrated game
├── requirements.txt            # Dependencies
├── INTEGRATION_GUIDE.md        # This guide
└── your_games/                 # Your PyGame files
```

## 🔍 Testing & Debugging

### **Test Backend Connection**
```bash
cd pyGame
python game_api_client.py
```

### **Test Integration**
```bash
python game_integration.py
```

### **Common Issues:**
- **Backend not running**: Start with `python main.py` in backend folder
- **Import errors**: Install requirements with `pip install -r requirements.txt`
- **Authentication fails**: Use test user `testuser/password123`

## 🚀 Deployment

### **Production Checklist:**
- [ ] Update backend URL in integration code
- [ ] Ensure backend is deployed and accessible
- [ ] Test authentication with production users
- [ ] Verify score submission works
- [ ] Check leaderboard functionality

## 🎯 Example: Complete Integration

See `SIHGame1_integrated.py` for a complete example showing:
- Login screen integration
- Game session management  
- Score submission
- Online/offline mode handling
- Game over screen with score display
- Restart functionality

## 🤝 Benefits

### **For Players:**
- ✅ **Seamless Experience** - Play games, track progress, compete
- ✅ **Cross-Platform** - Scores sync between PyGame and Flutter app
- ✅ **Social Features** - Leaderboards and competition
- ✅ **Progress Tracking** - See improvement over time

### **For Developers:**
- ✅ **Easy Integration** - Just a few lines of code
- ✅ **Automatic Features** - Login, scores, progress built-in
- ✅ **No Database Code** - Backend handles all data
- ✅ **Future-Proof** - Easy to extend and modify

---

## 🎉 **Your PyGame is now ready for the StudyFun ecosystem!**

With this integration, your educational PyGame becomes part of a comprehensive learning platform that connects with Flutter mobile apps and provides a complete educational experience for students.

**Happy Gaming! 🎮**
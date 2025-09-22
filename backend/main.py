from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from database import db
from config.config import Config
import os

# Initialize Flask app
app = Flask(__name__)
app.config.from_object(Config)

# Initialize extensions
db.init_app(app)
cors = CORS(app)
jwt = JWTManager(app)

# Import routes after db initialization to avoid circular imports
from routes.auth_routes import auth_bp
from routes.class_routes import class_bp
from routes.subject_routes import subject_bp
from routes.game_routes import game_bp
from routes.score_routes import score_bp

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(class_bp, url_prefix='/api/classes')
app.register_blueprint(subject_bp, url_prefix='/api/subjects')
app.register_blueprint(game_bp, url_prefix='/api/games')
app.register_blueprint(score_bp, url_prefix='/api/scores')

# Import models after db initialization
from models.user import User
from models.class_model import Class
from models.subject import Subject
from models.game import Game
from models.score import Score

@app.route('/')
def home():
    return {'message': 'StudyFun Backend API is running!', 'status': 'success'}

@app.route('/api/health')
def health_check():
    return {'status': 'healthy', 'message': 'Backend is operational'}

if __name__ == '__main__':
    with app.app_context():
        # Create tables if they don't exist
        db.create_all()
        print("Database tables created successfully!")
    
    # Run the app
    app.run(debug=True, host='0.0.0.0', port=5000)
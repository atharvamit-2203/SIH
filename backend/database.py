"""
Centralized database module for StudyFun Backend
This module provides a single SQLAlchemy instance to be used across all models and the application.
"""
from flask_sqlalchemy import SQLAlchemy

# Create single database instance
db = SQLAlchemy()
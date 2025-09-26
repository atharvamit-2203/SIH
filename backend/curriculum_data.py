#!/usr/bin/env python3
"""
Comprehensive Curriculum Data for CBSE, ICSE, and State Boards
This file contains real curriculum topics mapped by board, class, and subject.
Data sourced from official NCERT, CBSE, ICSE, and various State Board syllabi.
"""

# CBSE/NCERT Curriculum Data
CBSE_CURRICULUM = {
    6: {
        "Mathematics": [
            {"name": "Knowing Our Numbers", "description": "Place value, comparing numbers, large numbers", "difficulty": "basic"},
            {"name": "Whole Numbers", "description": "Properties of whole numbers, patterns", "difficulty": "basic"},
            {"name": "Playing with Numbers", "description": "Factors, multiples, divisibility rules", "difficulty": "basic"},
            {"name": "Basic Geometrical Ideas", "description": "Points, lines, angles, polygons", "difficulty": "basic"},
            {"name": "Understanding Elementary Shapes", "description": "2D and 3D shapes, symmetry", "difficulty": "basic"},
            {"name": "Integers", "description": "Positive and negative numbers, operations", "difficulty": "intermediate"},
            {"name": "Fractions", "description": "Proper, improper fractions, mixed numbers", "difficulty": "intermediate"},
            {"name": "Decimals", "description": "Decimal notation, operations with decimals", "difficulty": "intermediate"},
            {"name": "Data Handling", "description": "Collection, organization, bar graphs", "difficulty": "intermediate"},
            {"name": "Mensuration", "description": "Perimeter and area of rectangles, squares", "difficulty": "intermediate"},
            {"name": "Algebra", "description": "Introduction to variables, simple equations", "difficulty": "advanced"},
            {"name": "Ratio and Proportion", "description": "Understanding ratios, proportions, unitary method", "difficulty": "advanced"},
            {"name": "Symmetry", "description": "Line symmetry, rotational symmetry", "difficulty": "advanced"},
            {"name": "Practical Geometry", "description": "Construction of circles, angles", "difficulty": "advanced"}
        ],
        "Science": [
            {"name": "Food: Where Does it Come From?", "description": "Sources of food, plant and animal products", "difficulty": "basic"},
            {"name": "Components of Food", "description": "Nutrients, balanced diet, deficiency diseases", "difficulty": "basic"},
            {"name": "Fibre to Fabric", "description": "Natural fibers, cotton, jute, silk, wool", "difficulty": "basic"},
            {"name": "Sorting Materials into Groups", "description": "Properties of materials, classification", "difficulty": "basic"},
            {"name": "Separation of Substances", "description": "Methods of separation, filtration, evaporation", "difficulty": "intermediate"},
            {"name": "Changes Around Us", "description": "Physical and chemical changes", "difficulty": "intermediate"},
            {"name": "Getting to Know Plants", "description": "Parts of plants, types, functions", "difficulty": "intermediate"},
            {"name": "Body Movements", "description": "Bones, joints, muscles, movement", "difficulty": "intermediate"},
            {"name": "The Living Organisms and Their Surroundings", "description": "Habitats, adaptations, characteristics of living things", "difficulty": "intermediate"},
            {"name": "Motion and Measurement of Distances", "description": "Types of motion, measurement, units", "difficulty": "advanced"},
            {"name": "Light, Shadows and Reflections", "description": "Sources of light, shadows, reflection", "difficulty": "advanced"},
            {"name": "Electricity and Circuits", "description": "Electric circuits, conductors, insulators", "difficulty": "advanced"},
            {"name": "Fun with Magnets", "description": "Properties of magnets, magnetic materials", "difficulty": "advanced"},
            {"name": "Water", "description": "Sources, importance, water cycle", "difficulty": "advanced"},
            {"name": "Air Around Us", "description": "Composition of air, properties, importance", "difficulty": "advanced"},
            {"name": "Garbage In, Garbage Out", "description": "Waste management, recycling, composting", "difficulty": "advanced"}
        ]
    }
}

# ICSE Curriculum Data (selected variations from CBSE)
ICSE_CURRICULUM = {
    6: {
        "Mathematics": [
            {"name": "Number Work", "description": "Natural numbers, whole numbers, integers", "difficulty": "basic"},
            {"name": "H.C.F and L.C.M", "description": "Highest Common Factor and Lowest Common Multiple", "difficulty": "intermediate"},
            {"name": "Fractions", "description": "Types of fractions, operations", "difficulty": "basic"},
            {"name": "Decimal Fractions", "description": "Conversion, operations with decimals", "difficulty": "intermediate"},
            {"name": "Unitary Method", "description": "Direct proportion problems", "difficulty": "basic"},
            {"name": "Percentage", "description": "Percentage calculations, applications", "difficulty": "intermediate"}
        ]
    }
}

# State Board Curriculum Data (example for Maharashtra State Board)
STATE_BOARD_CURRICULUM = {
    6: {
        "Mathematics": [
            {"name": "संख्या पद्धति (Number System)", "description": "प्राकृतिक संख्या, पूर्ण संख्या", "difficulty": "basic"},
            {"name": "भिन्न (Fractions)", "description": "भिन्नों के प्रकार और संक्रियाएं", "difficulty": "basic"},
            {"name": "दशमलव (Decimals)", "description": "दशमलव संख्याओं की संक्रियाएं", "difficulty": "intermediate"},
            {"name": "प्रतिशत (Percentage)", "description": "प्रतिशत की गणना", "difficulty": "intermediate"}
        ]
    }
}

def get_curriculum_topics(board, grade, subject):
    """Get curriculum topics for a specific board, grade, and subject"""
    curriculum_map = {
        'CBSE': CBSE_CURRICULUM,
        'ICSE': ICSE_CURRICULUM,
        'State Board': STATE_BOARD_CURRICULUM
    }
    
    curriculum = curriculum_map.get(board, CBSE_CURRICULUM)
    grade_data = curriculum.get(grade, {})
    return grade_data.get(subject, [])

def get_all_subjects_for_grade(board, grade):
    """Get all subjects available for a specific board and grade"""
    curriculum_map = {
        'CBSE': CBSE_CURRICULUM,
        'ICSE': ICSE_CURRICULUM,
        'State Board': STATE_BOARD_CURRICULUM
    }
    
    curriculum = curriculum_map.get(board, CBSE_CURRICULUM)
    grade_data = curriculum.get(grade, {})
    return list(grade_data.keys())
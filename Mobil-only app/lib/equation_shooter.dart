import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'database_helper.dart';

// The Flutter widget that hosts the Flame game and the UI
class EquationShooterGameWidget extends StatefulWidget {
  @override
  _EquationShooterGameWidgetState createState() => _EquationShooterGameWidgetState();
}

class _EquationShooterGameWidgetState extends State<EquationShooterGameWidget> {
  late final EquationShooterGame _game;
  String _inputString = '';
  int _difficulty = 1;
  bool _showDifficultySelector = true;

  @override
  void initState() {
    super.initState();
    _game = EquationShooterGame(
      onAnswerSubmitted: _checkAnswer,
      onGameOver: _handleGameOver,
      difficulty: _difficulty,
    );
  }

  void _checkAnswer(int correctAnswer) {
    if (_inputString.isNotEmpty) {
      if (int.tryParse(_inputString) == correctAnswer) {
        _game.correctAnswer();
      } else {
        _game.wrongAnswer();
      }
      setState(() {
        _inputString = '';
      });
    }
  }

  void _handleGameOver(int finalScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over!', style: TextStyle(fontFamily: 'PressStart2P')),
          content: Text('Your final score is: $finalScore', style: TextStyle(fontFamily: 'PressStart2P')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(fontFamily: 'PressStart2P')),
            ),
          ],
        );
      },
    );
  }

  void _onNumberPadTap(String value) {
    setState(() {
      _inputString += value;
    });
  }

  void _onBackspaceTap() {
    if (_inputString.isNotEmpty) {
      setState(() {
        _inputString = _inputString.substring(0, _inputString.length - 1);
      });
    }
  }

  void _startGame() {
    setState(() {
      _showDifficultySelector = false;
      _game.difficulty = _difficulty;
      _game.resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF88D8FF), Color(0xFFF3C7FF)],
              ),
            ),
          ),
          Positioned.fill(
            child: GameWidget(game: _game),
          ),
          if (_showDifficultySelector)
            _buildDifficultySelector(),
          if (!_showDifficultySelector)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      _inputString.isEmpty ? 'Type your answer...' : _inputString,
                      style: TextStyle(
                        fontSize: 18,
                        color: _inputString.isEmpty ? Colors.grey : Colors.black,
                        fontFamily: 'PressStart2P',
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildNumberKeyboard(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Difficulty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'PressStart2P',
                color: Color(0xFF1B2E68),
              ),
            ),
            SizedBox(height: 20),
            _buildDifficultyButton(1, 'EASY'),
            _buildDifficultyButton(2, 'MEDIUM'),
            _buildDifficultyButton(3, 'HARD'),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(int value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _difficulty = value;
          });
          _startGame();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _difficulty == value ? Color(0xFFF3C7FF) : Color(0xFFFFE8A3),
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.black, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'PressStart2P',
            color: Color(0xFF1B2E68),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberKeyboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('0'),
            _buildBackspaceButton(),
            _buildEnterButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onNumberPadTap(number),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Color(0xFFB5FFFC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2E68),
              fontFamily: 'PressStart2P',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: _onBackspaceTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Color(0xFFFFE8A3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          child: Icon(Icons.backspace, color: Color(0xFF1B2E68), size: 20),
        ),
      ),
    );
  }

  Widget _buildEnterButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            _checkAnswer(_game.currentEquation.equation['answer']);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Color(0xFFF3C7FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: Colors.black, width: 2),
          ),
          child: Icon(Icons.check, color: Color(0xFF1B2E68), size: 20),
        ),
      ),
    );
  }
}

// The core Flame game class
class EquationShooterGame extends FlameGame {
  int score = 0;
  int level = 1;
  int streak = 0;
  int difficulty;
  bool isGameOver = false;

  final Function(int) onAnswerSubmitted;
  final Function(int) onGameOver;

  late TextComponent scoreText;
  late TextComponent levelText;
  late EquationComponent currentEquation;
  
  final _random = Random();
  final double missPoint = 0.6; // Miss when equation goes beyond 60% of screen height
  final double targetY = 0.2; // Spawn point for the equation

  EquationShooterGame({
    required this.onAnswerSubmitted,
    required this.onGameOver,
    this.difficulty = 1,
  });

  @override
  Future<void> onLoad() async {
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'PressStart2P')),
    );
    levelText = TextComponent(
      text: 'Level: 1',
      position: Vector2(size.x - 150, 20),
      textRenderer: TextPaint(style: const TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'PressStart2P')),
    );
    
    add(scoreText);
    add(levelText);
    
    spawnEquation();
  }
  
  void resetGame() {
    score = 0;
    level = 1;
    streak = 0;
    isGameOver = false;
    
    scoreText.text = 'Score: 0';
    levelText.text = 'Level: 1';
    
    // Remove existing equations
    removeAll(children.whereType<EquationComponent>());
    
    spawnEquation();
  }
  
  @override
  void update(double dt) {
    if (isGameOver) {
      return;
    }
    super.update(dt);
    
    currentEquation.y += _getSpeed() * dt;
    
    if (currentEquation.y > size.y * missPoint) {
      wrongAnswer();
    }
  }
  
  double _getSpeed() {
    switch(difficulty) {
      case 1:
        return 50;
      case 2:
        return 75;
      case 3:
        return 100;
      default:
        return 50;
    }
  }

  void checkAnswer(int? answer) {
    if (answer != null && answer == currentEquation.equation['answer']) {
      correctAnswer();
    } else {
      wrongAnswer();
    }
  }

  void correctAnswer() {
    score += 10;
    streak++;
    
    if (score ~/ 50 + 1 > level) {
      level = score ~/ 50 + 1;
    }
    
    scoreText.text = 'Score: $score';
    levelText.text = 'Level: $level';
    
    currentEquation.removeFromParent();
    spawnEquation();
  }
  
  void wrongAnswer() {
    isGameOver = true;
    onGameOver(score);
    currentEquation.removeFromParent();
  }
  
  void endGame() async {
    isGameOver = true;
    
    final finalScore = {
      'user_id': 1,
      'game_name': 'Equation Shooter',
      'score': score,
    };
    await DatabaseHelper().insertScore(finalScore);
    
    onGameOver(score);
  }
  
  void spawnEquation() {
    final eq = generateEquation();
    currentEquation = EquationComponent(equation: eq, game: this);
    add(currentEquation);
  }
  
  Map<String, dynamic> generateEquation() {
    final a = _random.nextInt(10) + 1;
    final x = _random.nextInt(10) + 1;
    final b = _random.nextInt(20) - 10;
    final c = a * x + b;
    
    String equationString;
    if (b > 0) {
      equationString = '$a' 'x + ' '$b' ' = ' '$c';
    } else if (b < 0) {
      equationString = '$a' 'x - ' '${b.abs()}' ' = ' '$c';
    } else {
      equationString = '$a' 'x = ' '$c';
    }
    
    return {'equation': equationString, 'answer': x};
  }
}

class EquationComponent extends PositionComponent {
  final Map<String, dynamic> equation;
  final EquationShooterGame game;
  final double speed;
  
  EquationComponent({required this.equation, required this.game}) : 
    speed = game._getSpeed(),
    super(size: Vector2(200, 50));
  
  @override
  void onMount() {
    super.onMount();
    x = (game.size.x - size.x) / 2;
    y = game.size.y * game.targetY;
  }
  
  @override
  void render(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: equation['equation'],
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontFamily: 'PressStart2P',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    final paint = BasicPalette.blue.paint()
      ..style = PaintingStyle.fill;
    
    // Draw background rectangle that is slightly larger
    final rect = size.toRect();
    final paddedRect = Rect.fromCenter(
      center: rect.center,
      width: textPainter.width + 20,
      height: textPainter.height + 10,
    );
    canvas.drawRect(paddedRect, paint);
    
    final textX = (size.x - textPainter.width) / 2;
    final textY = (size.y - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(textX, textY));
  }
}
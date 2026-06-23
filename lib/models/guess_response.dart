import 'game.dart';
import 'guess_hints.dart';

class GuessResponse {
  final bool isCorrect;
  final int attemptsUsed;
  final int attemptsRemaining;
  final GameStatus gameStatus;
  final GuessHints hints;
  final String? answer;

  const GuessResponse({
    required this.isCorrect,
    required this.attemptsUsed,
    required this.attemptsRemaining,
    required this.gameStatus,
    required this.hints,
    this.answer,
  });

  factory GuessResponse.fromJson(Map<String, dynamic> json) {
    return GuessResponse(
      isCorrect: json['isCorrect'] as bool,
      attemptsUsed: json['attemptsUsed'] as int,
      attemptsRemaining: json['attemptsRemaining'] as int,
      gameStatus: _parseGameStatus(json['gameStatus']),
      hints: GuessHints.fromJson(json['hints'] as Map<String, dynamic>),
      answer: json['answer'] as String?,
    );
  }

  bool get isGameOver =>
      gameStatus == GameStatus.won || gameStatus == GameStatus.lost;
}

GameStatus _parseGameStatus(dynamic value) {
  if (value is int) {
    return GameStatus.values[value];
  }
  switch (value.toString().toLowerCase()) {
    case 'won':
      return GameStatus.won;
    case 'lost':
      return GameStatus.lost;
    default:
      return GameStatus.inProgress;
  }
}

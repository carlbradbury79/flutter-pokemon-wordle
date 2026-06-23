import 'guess_hints.dart';

enum GameStatus { inProgress, won, lost }

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

class AttemptRecord {
  final String pokemonName;
  final bool isCorrect;
  final GuessHints hints;

  const AttemptRecord({
    required this.pokemonName,
    required this.isCorrect,
    required this.hints,
  });

  factory AttemptRecord.fromJson(Map<String, dynamic> json) {
    return AttemptRecord(
      pokemonName: json['pokemonName'] as String,
      isCorrect: json['isCorrect'] as bool,
      hints: GuessHints.fromJson(json['hints'] as Map<String, dynamic>),
    );
  }
}

class Game {
  final String gameId;
  final DateTime date;
  final GameStatus status;
  final int attemptsUsed;
  final int attemptsRemaining;
  final int maxAttempts;
  final List<AttemptRecord> attempts;
  final String? answer;

  const Game({
    required this.gameId,
    required this.date,
    required this.status,
    required this.attemptsUsed,
    required this.attemptsRemaining,
    required this.maxAttempts,
    required this.attempts,
    this.answer,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final attemptsList = (json['attempts'] as List<dynamic>)
        .map((e) => AttemptRecord.fromJson(e as Map<String, dynamic>))
        .toList();

    return Game(
      gameId: json['gameId'] as String,
      date: DateTime.parse(json['date'] as String),
      status: _parseGameStatus(json['status']),
      attemptsUsed: json['attemptsUsed'] as int,
      attemptsRemaining: json['attemptsRemaining'] as int,
      maxAttempts: json['maxAttempts'] as int,
      attempts: attemptsList,
      answer: json['answer'] as String?,
    );
  }

  bool get isOver => status == GameStatus.won || status == GameStatus.lost;
}

class CreateGameResponse {
  final String gameId;
  final DateTime date;
  final int maxAttempts;
  final String message;

  const CreateGameResponse({
    required this.gameId,
    required this.date,
    required this.maxAttempts,
    required this.message,
  });

  factory CreateGameResponse.fromJson(Map<String, dynamic> json) {
    return CreateGameResponse(
      gameId: json['gameId'] as String,
      date: DateTime.parse(json['date'] as String),
      maxAttempts: json['maxAttempts'] as int,
      message: json['message'] as String,
    );
  }
}

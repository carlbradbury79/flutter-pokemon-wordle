import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pokemon_wordle/models/daily_pokemon.dart';
import 'package:flutter_pokemon_wordle/models/game.dart';
import 'package:flutter_pokemon_wordle/models/guess_hints.dart';
import 'package:flutter_pokemon_wordle/models/guess_response.dart';

void main() {
  group('DailyPokemon', () {
    test('fromJson parses correctly', () {
      final json = {'date': '2024-01-15', 'pokemonNumber': 25};
      final result = DailyPokemon.fromJson(json);
      expect(result.pokemonNumber, 25);
    });
  });

  group('GuessHints', () {
    test('fromJson parses correctly', () {
      final json = {'sharesType': true, 'generationHint': 'higher'};
      final result = GuessHints.fromJson(json);
      expect(result.sharesType, true);
      expect(result.generationHint, 'higher');
    });
  });

  group('Game', () {
    test('fromJson parses InProgress game', () {
      final json = {
        'gameId': '550e8400-e29b-41d4-a716-446655440000',
        'date': '2024-01-15',
        'status': 'inProgress',
        'attemptsUsed': 1,
        'attemptsRemaining': 5,
        'maxAttempts': 6,
        'attempts': [
          {
            'pokemonName': 'pikachu',
            'isCorrect': false,
            'hints': {'sharesType': false, 'generationHint': 'correct'},
          }
        ],
        'answer': null,
      };
      final game = Game.fromJson(json);
      expect(game.status, GameStatus.inProgress);
      expect(game.attemptsUsed, 1);
      expect(game.attempts.length, 1);
      expect(game.attempts[0].pokemonName, 'pikachu');
      expect(game.isOver, false);
    });

    test('fromJson parses Won game with answer', () {
      final json = {
        'gameId': '550e8400-e29b-41d4-a716-446655440001',
        'date': '2024-01-15',
        'status': 'won',
        'attemptsUsed': 3,
        'attemptsRemaining': 3,
        'maxAttempts': 6,
        'attempts': [],
        'answer': 'bulbasaur',
      };
      final game = Game.fromJson(json);
      expect(game.status, GameStatus.won);
      expect(game.answer, 'bulbasaur');
      expect(game.isOver, true);
    });

    test('fromJson parses numeric status', () {
      final json = {
        'gameId': '550e8400-e29b-41d4-a716-446655440002',
        'date': '2024-01-15',
        'status': 2, // Lost = 2 in enum
        'attemptsUsed': 6,
        'attemptsRemaining': 0,
        'maxAttempts': 6,
        'attempts': [],
        'answer': 'charizard',
      };
      final game = Game.fromJson(json);
      expect(game.status, GameStatus.lost);
      expect(game.isOver, true);
    });
  });

  group('CreateGameResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        'gameId': '550e8400-e29b-41d4-a716-446655440003',
        'date': '2024-01-15',
        'maxAttempts': 6,
        'message': 'Game created',
      };
      final result = CreateGameResponse.fromJson(json);
      expect(result.gameId, '550e8400-e29b-41d4-a716-446655440003');
      expect(result.maxAttempts, 6);
      expect(result.message, 'Game created');
    });
  });

  group('GuessResponse', () {
    test('fromJson parses correct guess', () {
      final json = {
        'isCorrect': true,
        'attemptsUsed': 2,
        'attemptsRemaining': 4,
        'gameStatus': 'won',
        'hints': {'sharesType': true, 'generationHint': 'correct'},
        'answer': 'mew',
      };
      final result = GuessResponse.fromJson(json);
      expect(result.isCorrect, true);
      expect(result.gameStatus, GameStatus.won);
      expect(result.answer, 'mew');
      expect(result.isGameOver, true);
    });

    test('fromJson parses incorrect guess', () {
      final json = {
        'isCorrect': false,
        'attemptsUsed': 1,
        'attemptsRemaining': 5,
        'gameStatus': 'inProgress',
        'hints': {'sharesType': false, 'generationHint': 'lower'},
        'answer': null,
      };
      final result = GuessResponse.fromJson(json);
      expect(result.isCorrect, false);
      expect(result.gameStatus, GameStatus.inProgress);
      expect(result.isGameOver, false);
      expect(result.hints.generationHint, 'lower');
    });
  });
}

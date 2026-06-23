import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/daily_pokemon.dart';
import '../models/game.dart';
import '../models/guess_response.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  final String baseUrl;
  final http.Client _client;

  ApiService({
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? 'http://localhost:5141',
        _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<DailyPokemon> getDailyPokemon() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/daily-pokemon'),
      headers: _headers,
    );
    _checkStatus(response);
    return DailyPokemon.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<CreateGameResponse> startGame() async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/games'),
      headers: _headers,
    );
    _checkStatus(response);
    return CreateGameResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Game> getGame(String gameId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/games/$gameId'),
      headers: _headers,
    );
    _checkStatus(response);
    return Game.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<GuessResponse> submitGuess(String gameId, String pokemonName) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/games/$gameId/guesses'),
      headers: _headers,
      body: jsonEncode({'pokemonName': pokemonName}),
    );
    _checkStatus(response);
    return GuessResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    String message;
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      message = (body['message'] ?? body['title'] ?? response.body).toString();
    } catch (_) {
      message = response.body.isNotEmpty ? response.body : 'Unknown error';
    }

    throw ApiException(message, statusCode: response.statusCode);
  }

  void dispose() {
    _client.close();
  }
}

import 'package:flutter/material.dart';

import 'screens/game_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const PokemonWordleApp());
}

class PokemonWordleApp extends StatelessWidget {
  const PokemonWordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Wordle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEE1515), // Pokéball red
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEE1515),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: GameScreen(
        apiService: ApiService(),
      ),
    );
  }
}

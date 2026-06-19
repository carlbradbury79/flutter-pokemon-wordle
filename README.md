# flutter-pokemon-wordle

A Flutter frontend for the [dotnet-pokemon-api-2](https://github.com/carlbradbury79/dotnet-pokemon-api-2) — a Pokémon Wordle-like guessing game.

## 🎮 How to play

1. The app shows today's Pokédex **number** as a hint (not the name).
2. Type a Pokémon name and press **Send** to guess.
3. Each guess shows two hints:
   - **Type** — does your guess share a type with today's Pokémon?
   - **Gen** — is the answer a higher ⬆️, lower ⬇️, or the same ✅ generation?
4. You have **6 attempts** to guess the correct Pokémon.

## 🚀 Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0
- The [dotnet-pokemon-api-2](https://github.com/carlbradbury79/dotnet-pokemon-api-2) backend running locally

### Run the API backend

```bash
cd <path-to-dotnet-pokemon-api-2>/src/PokemonWordle.Api
dotnet run
# API starts at http://localhost:5141
```

### Run the Flutter app

```bash
flutter pub get
flutter run
```

The app connects to `http://localhost:5141` by default. To use a different URL,
edit `baseUrl` in `lib/services/api_service.dart`.

## 🗂 Project structure

```
lib/
  main.dart                  ← App entry point & theme
  models/
    daily_pokemon.dart       ← DailyPokemon model
    game.dart                ← Game, AttemptRecord, CreateGameResponse models
    guess_hints.dart         ← GuessHints model
    guess_response.dart      ← GuessResponse model
  services/
    api_service.dart         ← HTTP client for all 4 API endpoints
  screens/
    game_screen.dart         ← Main game screen
  widgets/
    guess_tile.dart          ← Single guess row with hint chips
test/
  models_test.dart           ← Unit tests for JSON parsing
```

## 🧪 Running tests

```bash
flutter test
```

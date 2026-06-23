import 'package:flutter/material.dart';

import '../models/daily_pokemon.dart';
import '../models/game.dart';
import '../services/api_service.dart';
import '../widgets/guess_tile.dart';

class GameScreen extends StatefulWidget {
  final ApiService apiService;

  const GameScreen({super.key, required this.apiService});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _guessController = TextEditingController();
  final FocusNode _guessFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  DailyPokemon? _dailyPokemon;
  Game? _game;
  String? _gameId;
  bool _loading = true;
  bool _submitting = false;
  String? _error;
  String? _guessError;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _guessController.dispose();
    _guessFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final daily = await widget.apiService.getDailyPokemon();
      final created = await widget.apiService.startGame();
      final game = await widget.apiService.getGame(created.gameId);
      setState(() {
        _dailyPokemon = daily;
        _gameId = created.gameId;
        _game = game;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = _friendlyError(e);
        _loading = false;
      });
    }
  }

  Future<void> _submitGuess() async {
    final guess = _guessController.text.trim();
    if (guess.isEmpty) return;

    setState(() {
      _submitting = true;
      _guessError = null;
    });

    try {
      await widget.apiService.submitGuess(_gameId!, guess);
      final updatedGame = await widget.apiService.getGame(_gameId!);
      _guessController.clear();
      setState(() {
        _game = updatedGame;
        _submitting = false;
      });
      _scrollToBottom();
      if (!updatedGame.isOver) {
        _guessFocus.requestFocus();
      }
    } on ApiException catch (e) {
      setState(() {
        _guessError = e.message;
        _submitting = false;
      });
    } catch (e) {
      setState(() {
        _guessError = _friendlyError(e);
        _submitting = false;
      });
    }
  }

  Future<void> _newGame() async {
    setState(() {
      _loading = true;
      _error = null;
      _game = null;
      _gameId = null;
      _guessController.clear();
      _guessError = null;
    });
    try {
      final created = await widget.apiService.startGame();
      final game = await widget.apiService.getGame(created.gameId);
      setState(() {
        _gameId = created.gameId;
        _game = game;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = _friendlyError(e);
        _loading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _friendlyError(Object e) {
    if (e is ApiException) return e.message;
    return 'Something went wrong. Is the API running at ${widget.apiService.baseUrl}?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Wordle'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_game != null && !_loading)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'New game',
              onPressed: _newGame,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _buildGame(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Could not start game',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _init,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGame() {
    final game = _game!;
    return Column(
      children: [
        _buildHintBanner(),
        Expanded(
          child: game.attempts.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: game.attempts.length,
                  itemBuilder: (context, index) => GuessTile(
                    attempt: game.attempts[index],
                    attemptNumber: index + 1,
                  ),
                ),
        ),
        if (game.isOver) _buildGameOverBanner(game),
        if (!game.isOver) _buildInputRow(),
      ],
    );
  }

  Widget _buildHintBanner() {
    final theme = Theme.of(context);
    final game = _game!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: theme.colorScheme.primaryContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎯 ', style: TextStyle(fontSize: 18)),
          if (_dailyPokemon != null)
            Text(
              'Today\'s Pokémon is #${_dailyPokemon!.pokemonNumber} (${_dailyPokemon!.pokemonNameLength} letters)',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          const Spacer(),
          Text(
            '${game.attemptsUsed}/${game.maxAttempts}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🐾', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Guess the Pokémon!',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'You have ${_game!.maxAttempts} attempts.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverBanner(Game game) {
    final won = game.status == GameStatus.won;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: won ? Colors.green.shade700 : Colors.red.shade700,
      child: Column(
        children: [
          Text(
            won ? '🎉 You got it!' : '😞 Game over!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (game.answer != null) ...[
            const SizedBox(height: 4),
            Text(
              'The answer was: ${_capitalize(game.answer!)}',
              style: const TextStyle(color: Colors.white70, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _newGame,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text(
              'Play Again',
              style: TextStyle(color: Colors.white),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_guessError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  _guessError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 13,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _guessController,
                    focusNode: _guessFocus,
                    autofocus: true,
                    enabled: !_submitting,
                    textCapitalization: TextCapitalization.none,
                    decoration: InputDecoration(
                      hintText: 'Enter Pokémon name…',
                      prefixIcon: const Icon(Icons.catching_pokemon),
                      border: const OutlineInputBorder(),
                      errorText: null,
                    ),
                    onSubmitted: (_) => _submitGuess(),
                    onChanged: (_) {
                      if (_guessError != null) {
                        setState(() => _guessError = null);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                _submitting
                    ? const SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : FilledButton(
                        onPressed: _submitGuess,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(48, 56),
                        ),
                        child: const Icon(Icons.send),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

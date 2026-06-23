import 'package:flutter/material.dart';

import '../models/game.dart';

class GuessTile extends StatelessWidget {
  final AttemptRecord attempt;
  final int attemptNumber;

  const GuessTile({
    super.key,
    required this.attempt,
    required this.attemptNumber,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: attempt.isCorrect
          ? Colors.green.shade700
          : theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Attempt number badge
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$attemptNumber',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Pokémon name
            Expanded(
              child: Text(
                _capitalize(attempt.pokemonName),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: attempt.isCorrect ? Colors.white : null,
                ),
              ),
            ),

            // Hint chips
            _HintChip(
              icon: attempt.hints.sharesType ? Icons.check : Icons.close,
              label: 'Type',
              positive: attempt.hints.sharesType,
            ),
            const SizedBox(width: 6),
            _GenerationChip(generationHint: attempt.hints.generationHint),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class _HintChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool positive;

  const _HintChip({
    required this.icon,
    required this.label,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? Colors.green.shade600 : Colors.red.shade600;
    return Tooltip(
      message: positive ? 'Shares a type' : 'Different type',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenerationChip extends StatelessWidget {
  final String generationHint;

  const _GenerationChip({required this.generationHint});

  @override
  Widget build(BuildContext context) {
    final (icon, color, tooltip) = switch (generationHint.toLowerCase()) {
      'correct' => (Icons.check_circle, Colors.green.shade600, 'Same generation'),
      'higher' => (Icons.arrow_upward, Colors.orange.shade600, 'Answer is higher gen'),
      'lower' => (Icons.arrow_downward, Colors.blue.shade600, 'Answer is lower gen'),
      _ => (Icons.help_outline, Colors.grey.shade600, generationHint),
    };

    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              'Gen',
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

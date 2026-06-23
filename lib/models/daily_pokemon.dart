class DailyPokemon {
  final DateTime date;
  final int pokemonNumber;
  final int pokemonNameLength;

  const DailyPokemon({
    required this.date,
    required this.pokemonNumber,
    required this.pokemonNameLength,
  });

  factory DailyPokemon.fromJson(Map<String, dynamic> json) {
    return DailyPokemon(
      date: DateTime.parse(json['date'] as String),
      pokemonNumber: json['pokemonNumber'] as int,
      pokemonNameLength: json['pokemonNameLength'] as int,
    );
  }
}

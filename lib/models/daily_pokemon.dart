class DailyPokemon {
  final DateTime date;
  final int pokemonNumber;

  const DailyPokemon({
    required this.date,
    required this.pokemonNumber,
  });

  factory DailyPokemon.fromJson(Map<String, dynamic> json) {
    return DailyPokemon(
      date: DateTime.parse(json['date'] as String),
      pokemonNumber: json['pokemonNumber'] as int,
    );
  }
}

class GuessHints {
  final bool sharesType;
  final String generationHint;

  const GuessHints({
    required this.sharesType,
    required this.generationHint,
  });

  factory GuessHints.fromJson(Map<String, dynamic> json) {
    return GuessHints(
      sharesType: json['sharesType'] as bool,
      generationHint: json['generationHint'] as String,
    );
  }
}

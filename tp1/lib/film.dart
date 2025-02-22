class Film {
  final String id;
  final String titre;
  final String image;
  final String resume;
  final String duree;
  final List<String> genre;
  final double note;
  final String realisateur;
  final List<String> acteurs;

  Film({
    required this.id,
    required this.titre,
    required this.image,
    required this.resume,
    required this.duree,
    required this.genre,
    required this.note,
    required this.realisateur,
    required this.acteurs,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['Id'] as String,
      titre: json['Title'] as String,
      image: json["PosterImage"] as String,
      resume: json['Summary'] as String,
      duree: json['Duration'] as String,
      genre: List<String>.from(json['Genre']),
      note: (json['Rating'] as num).toDouble(),
      realisateur: json['Director'] as String,
      acteurs: List<String>.from(json['MainActors']),
    );
  }
}
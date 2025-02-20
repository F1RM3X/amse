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
      titre: json['Titre'] as String,
      image: json["Image de l'affiche du film"] as String,
      resume: json['Résumé'] as String,
      duree: json['Durée'] as String,
      genre: List<String>.from(json['Genre']),
      note: (json['Note'] as num).toDouble(),
      realisateur: json['Réalisateur'] as String,
      acteurs: List<String>.from(json['Acteurs principaux']),
    );
  }
}

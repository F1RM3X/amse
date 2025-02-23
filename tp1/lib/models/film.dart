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

  //création d'objets films depuis le fichier json comportant les informations
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

  // stockage dans un Json des films likés et ajoutés à la WL pour pouvoir les récupérer au chargement de l'application
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': titre,
      'PosterImage': image,
      'Summary': resume,
      'Duration': duree,
      'Genre': genre,
      'Rating': note,
      'Director': realisateur,
      'MainActors': acteurs,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Film && titre == other.titre);

  @override
  int get hashCode => titre.hashCode;
}

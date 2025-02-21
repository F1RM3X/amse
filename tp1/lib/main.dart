import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

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

class MyAppState extends ChangeNotifier {
  List<Film> films = [];
  bool isLoading = true;
  String? error;

  MyAppState() {
    loadFilms();
  }

  Future<void> loadFilms() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/films.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);
      films = jsonResponse.map((film) => Film.fromJson(film)).toList();
    } catch (e) {
      error = 'Erreur lors du chargement des films: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Films',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FilmsListPage(),
    );
  }
}

class FilmsListPage extends StatelessWidget {
  const FilmsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Films')),
      body: Consumer<MyAppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (appState.error != null) {
            return Center(child: Text(appState.error!));
          } else if (appState.films.isEmpty) {
            return const Center(child: Text('Aucun film trouvé.'));
          }

          return ListView.builder(
            itemCount: appState.films.length,
            itemBuilder: (context, index) {
              final film = appState.films[index];
              return ListTile(
                leading: Image.network(
                  film.image,
                  width: 50,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image),
                ),
                title: Text(film.titre),
                subtitle: Text(film.realisateur),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilmDetailPage(film: film),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FilmDetailPage extends StatelessWidget {
  final Film film;

  const FilmDetailPage({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(film.titre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(film.image, height: 300)),
            const SizedBox(height: 16),
            Text(
              film.titre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Réalisateur: ${film.realisateur}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Acteurs: ${film.acteurs.join(', ')}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Durée: ${film.duree}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Genre: ${film.genre.join(', ')}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Note: ${film.note}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(film.resume, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAppState(),
      child: MaterialApp(
        title: 'Film App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Film> films = [];
  List<Film> favoris = [];
  String? error;
  bool isLoading = true;

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

  void toggleFavori(Film film) {
    if (favoris.contains(film)) {
      favoris.remove(film);
    } else {
      favoris.add(film);
    }
    notifyListeners();
  }
}

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
      image: json['Image de l\'affiche du film'] as String,
      resume: json['Résumé'] as String,
      duree: json['Durée'] as String,
      genre: List<String>.from(json['Genre']),
      note: (json['Note'] as num).toDouble(),
      realisateur: json['Réalisateur'] as String,
      acteurs: List<String>.from(json['Acteurs principaux']),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const FilmListScreen(),
    const FavorisScreen(),
    const DebugInspector(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Films',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bug_report),
            label: 'Debug',
          ),
        ],
      ),
    );
  }
}

class FilmListScreen extends StatelessWidget {
  const FilmListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    if (appState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appState.error != null) {
      return Center(child: Text(appState.error!));
    }

    return ListView.builder(
      itemCount: appState.films.length,
      itemBuilder: (context, index) {
        final film = appState.films[index];
        final isFavori = appState.favoris.contains(film);

        return ListTile(
          leading: Image.network(film.image, width: 50, fit: BoxFit.cover),
          title: Text(film.titre),
          subtitle: Text(film.realisateur),
          trailing: IconButton(
            icon: Icon(
              isFavori ? Icons.favorite : Icons.favorite_border,
              color: isFavori ? Colors.red : null,
            ),
            onPressed: () => appState.toggleFavori(film),
          ),
        );
      },
    );
  }
}

class FavorisScreen extends StatelessWidget {
  const FavorisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    if (appState.favoris.isEmpty) {
      return const Center(child: Text('Aucun film favori'));
    }

    return ListView.builder(
      itemCount: appState.favoris.length,
      itemBuilder: (context, index) {
        final film = appState.favoris[index];

        return ListTile(
          leading: Image.network(film.image, width: 50, fit: BoxFit.cover),
          title: Text(film.titre),
          subtitle: Text(film.realisateur),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle, color: Colors.red),
            onPressed: () => appState.toggleFavori(film),
          ),
        );
      },
    );
  }
}

class DebugInspector extends StatelessWidget {
  const DebugInspector({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Inspector')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('Films chargés: ${appState.films.length}'),
            Text('Favoris: ${appState.favoris.map((f) => f.titre).join(", ")}'),
            if (appState.error != null)
              Text('Erreur: ${appState.error}', style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => appState.loadFilms(),
              child: const Text('Recharger les films'),
            ),
          ],
        ),
      ),
    );
  }
}
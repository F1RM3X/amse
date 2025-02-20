import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'film.dart';

Future<List<Film>> loadFilms() async {
  final String jsonString = await rootBundle.loadString('assets/films.json');
  final List<dynamic> jsonResponse = json.decode(jsonString);
  return jsonResponse.map((film) => Film.fromJson(film)).toList();
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Films',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FilmsListPage(),
    );
  }
}

class FilmsListPage extends StatefulWidget {
  const FilmsListPage({super.key});
  
  @override
  _FilmsListPageState createState() => _FilmsListPageState();
}

class _FilmsListPageState extends State<FilmsListPage> {
  late Future<List<Film>> filmsFuture;
  
  @override
  void initState() {
    super.initState();
    filmsFuture = loadFilms();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Liste des Films')),
      body: FutureBuilder<List<Film>>(
        future: filmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun film trouvé.'));
          }
          
          final films = snapshot.data!;
          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
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

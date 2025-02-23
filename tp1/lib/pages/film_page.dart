import 'package:flutter/material.dart';
import '../models/film.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class FilmPage extends StatelessWidget {
  final Film film;

  FilmPage({required this.film}); //constructeur

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isLiked = appState.likes.contains(film);
    bool inWatchList = appState.watchList.contains(film);

    return Scaffold(
      appBar: AppBar(title: Text(film.titre)), //titre page
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              //image
              child: Image.asset(
                'lib/assets/${film.image}',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            //réalisateur
            Card(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Director: ${film.realisateur}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //acteurs
            Card(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    // colonne pour "Actors"
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Actors:', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    // colonne pour les acteurs
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            film.acteurs.join(', '),
                            style: const TextStyle(fontSize: 16),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            //genres
            Card(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Genre: ${film.genre.join(', ')}',
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            //durée et note
            Card(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Duration: ${film.duree}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),

                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Rating: ${film.note}/10',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            Text(
              //résulé
              film.resume,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1),
            const SizedBox(height: 10),
            Row(
              //boutons
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => appState.toggleLikes(film),
                ),
                IconButton(
                  icon: Icon(
                    inWatchList
                        ? Icons.watch_later
                        : Icons.watch_later_outlined,
                  ),
                  onPressed: () => appState.toggleWatchList(film),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/film.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class FilmPage extends StatelessWidget {
  final Film film;

  FilmPage({
    required this.film,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isLiked = appState.likes.contains(film);
    bool inWatchList = appState.watchList.contains(film);

    return Scaffold(
      appBar: AppBar(title: Text(film.titre)),
      body: SingleChildScrollView( // Permet le défilement si besoin
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return isWideScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image à gauche
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          'lib/assets/${film.image}',
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),

                      // Infos à droite
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              film.resume,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text('Director: ${film.realisateur}'),
                            Text('Duration: ${film.duree}'),
                            Text('Genre: ${film.genre.join(', ')}'),
                            Text('Rating: ${film.note}/10'),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                                  onPressed: () => appState.toggleLikes(film),
                                ),
                                IconButton(
                                  icon: Icon(inWatchList ? Icons.watch_later : Icons.watch_later_outlined),
                                  onPressed: () => appState.toggleWatchList(film),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image en haut sur petit écran
                      Center(
                        child: Image.asset(
                          'lib/assets/${film.image}',
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        film.resume,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text('Director: ${film.realisateur}'),
                      Text('Duration: ${film.duree}'),
                      Text('Genre: ${film.genre.join(', ')}'),
                      Text('Rating: ${film.note}/10'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                            onPressed: () => appState.toggleLikes(film),
                          ),
                          IconButton(
                            icon: Icon(inWatchList ? Icons.watch_later : Icons.watch_later_outlined),
                            onPressed: () => appState.toggleWatchList(film),
                          ),
                        ],
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

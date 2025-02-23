import 'package:flutter/material.dart';
import '../models/film.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class FilmPage extends StatelessWidget{
  final Film film;

  FilmPage({
    required this.film
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isLiked = appState.likes.contains(film);
    bool inWatchList = appState.watchList.contains(film);

    return Scaffold(
      appBar: AppBar(title: Text(film.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset('lib/assets/${film.image}', width: 200),
            ]),
              Column(
                children: [
                  
                  
                  Text(film.resume),
                  SizedBox(height: 10),
                  Text('Director: ${film.realisateur}'),
                  Text('Duration: ${film.duree}'),
                  Text('Genre: ${film.genre.join(', ')}'),
                  Text('Rating: ${film.note}/10'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                        onPressed: () {
                          appState.toggleLikes(film);
                        },
                      ),
                      IconButton(
                        icon: Icon(inWatchList ? Icons.watch_later : Icons.watch_later_outlined),
                        onPressed: () {
                          appState.toggleWatchList(film);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ]),
        )));}}
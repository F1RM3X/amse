import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'film_page.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();

    if (appState.isLoading){
      return const Center(
        child: CircularProgressIndicator()
        );
    }

    final genres = ['All'];
    for ( var film in appState.films){
      for (var genre in film.genre){
        if (genres.contains(genre)==false){
          genres.add(genre);
        }
      }
    }
    print(genres);

    final realisateurs = ['All'];
    for ( var film in appState.films){
        if (realisateurs.contains(film.realisateur)== false){
          realisateurs.add(film.realisateur);
        }
      
    }

    return Scaffold(
  appBar: AppBar(
    title: Center(child: Text('Great Movies App')),
  ),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        // Cette partie prend un espace limité et n'empêche pas l'AppBar d'être visible
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: appState.selectedGenre,
                  onChanged: (value) => appState.updateGenre(value!),
                  items: genres.map((genre) {
                    return DropdownMenuItem(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButton<String>(
                  value: appState.selectedDirector,
                  onChanged: (value) => appState.updateDirector(value!),
                  items: realisateurs.map((realisateur) {
                    return DropdownMenuItem(
                      value: realisateur,
                      child: Text(realisateur),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),

        // Utilisation de Expanded pour laisser de la place pour l'AppBar
        Expanded(
          child: ListView.builder(
            itemCount: appState.filteredFilms.length,
            itemBuilder: (context, index) {
              final film = appState.filteredFilms[index];
              return ListTile(
                leading: Image.asset('lib/assets/${film.image}', width: 50),
                title: Text(film.titre),
                subtitle: Text('${film.realisateur} - ${film.genre.join(',')}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FilmPage(film: film)),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  ),
);

    
  }
}
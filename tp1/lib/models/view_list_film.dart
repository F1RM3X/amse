import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'film.dart';
import '../pages/film_page.dart';

class ViewListFilm extends StatelessWidget{
  final String name;
  final List<Film> filmList;

  
  ViewListFilm({
    required this.name,
    required this.filmList

});
  
  
  
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();

    final genres = ['All'];
    for ( var film in filmList){
      for (var genre in film.genre){
        if (genres.contains(genre)==false){
          genres.add(genre);
        }
      }
    }
    

    final realisateurs = ['All'];
    for ( var film in filmList){
        if (realisateurs.contains(film.realisateur)== false){
          realisateurs.add(film.realisateur);
        }
      
    }




  return Scaffold(
  appBar: AppBar(
    title: Center(child: Text(name)),
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
                return Card(
                    child: ListTile(
                      leading: Image.asset('lib/assets/${film.image}', fit: BoxFit.cover),
                      title: Text(film.titre),
                      subtitle: Text('${film.realisateur} - ${film.genre.join(',')}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FilmPage(film: film)),
                        );
                      }
                    )
                );
              }))])));
}}




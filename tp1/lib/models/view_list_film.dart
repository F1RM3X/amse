import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'film.dart';
import '../pages/film_page.dart';

class ViewListFilm extends StatelessWidget{
  final String name;
  

  
  ViewListFilm({
    required this.name
    

});


  
  
  
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    List<Film> filmList = [];
    List<Film> filmListFiltered = [];
    String? selectedGenre;
    String? selectedDirector;
   

    if (name == 'Great Movies App'){
        filmList = appState.films;
        filmListFiltered = appState.filteredFilmsHome;
        selectedGenre = appState.selectedGenreHome;
        selectedDirector = appState.selectedDirectorHome;
        

    }
    else if (name == 'Like'){
        filmList = appState.likes;
        filmListFiltered = appState.filteredFilmsLike;
        selectedGenre = appState.selectedGenreLike;
        selectedDirector = appState.selectedDirectorLike;
    }
    else if (name == 'WatchList'){
        filmList = appState.watchList;
        filmListFiltered = appState.filteredFilmsWL;
        selectedGenre = appState.selectedGenreWL;
        selectedDirector = appState.selectedDirectorWL;
    }


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



  if (filmList.isEmpty) {
      return Scaffold(
      appBar: AppBar(title: Center(child: Text(name))),
      body:Center(child:Text('No films add yet.')),
      );
    }


  return Scaffold(
  appBar: AppBar(
    title: Center(child: Text(name)),
  ),
  body: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Titres alignés correctement
      Row(
        children: const [
          Expanded(child: Text('Filter by', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('Genre', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text('Director', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
      
      // Dropdowns alignés sous les bons titres
      Row(
        children: [
          Expanded(
            child: Container(), // Vide pour l'alignement sous "Filter by"
          ),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedGenre,
              onChanged: (value) => appState.updateGenre(value!, name),
              items: genres.map((genre) {
                return DropdownMenuItem(
                  value: genre,
                  child: Text(genre),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedDirector,
              onChanged: (value) => appState.updateDirector(value!, name),
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
    
    

        // Utilisation de Expanded pour laisser de la place pour l'AppBar
        Expanded(
        
            child: ListView.builder(
              itemCount: filmListFiltered.length,
              itemBuilder: (context, index) {
                final film = filmListFiltered[index];
                return Card(
                    child: ListTile(
                      leading: Image.asset('lib/assets/${film.image}', fit: BoxFit.cover),
                      title: Text(film.titre),
                      subtitle: Text('${film.realisateur} - ${film.genre.join(',')}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              appState.likes.contains(film) ? Icons.favorite : Icons.favorite_border,
                              
                            ),
                            onPressed: () => appState.toggleLikes(film),
                          ),
                          IconButton(
                            icon: Icon(
                              appState.watchList.contains(film) ? Icons.watch_later : Icons.watch_later_outlined,
                              
                            ),
                            onPressed: () => appState.toggleWatchList(film),
                          ),
                        ],
                      ),
                      
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FilmPage(film: film)),
                        );
                      }
                    )
                );}))])));}}

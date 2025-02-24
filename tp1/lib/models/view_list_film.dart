import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'film.dart';
import '../pages/film_page.dart';

//classe utilisée pour contruire les pages affichant une liste de films
class ViewListFilm extends StatelessWidget {
  final String
  name; //on récupère le nom de la page qui appelle la classe pour modifier des paramètres

  //constructeur
  ViewListFilm({required this.name});

  @override
  Widget build(BuildContext context) {
    //variables
    var appState = context.watch<MyAppState>();
    List<Film> filmList = [];
    List<Film> filmListFiltered = [];
    String? selectedGenre;
    String? selectedDirector;

    //adaptation des variables à la page qui appelle ViewListFilm
    if (name == 'Great Movies App') {
      filmList = appState.films;
      filmListFiltered = appState.filteredFilmsHome;
      selectedGenre = appState.selectedGenreHome;
      selectedDirector = appState.selectedDirectorHome;
    } else if (name == 'Likes') {
      filmList = appState.likes;
      filmListFiltered = appState.filteredFilmsLike;
      selectedGenre = appState.selectedGenreLike;
      selectedDirector = appState.selectedDirectorLike;
    } else if (name == 'WatchList') {
      filmList = appState.watchList;
      filmListFiltered = appState.filteredFilmsWL;
      selectedGenre = appState.selectedGenreWL;
      selectedDirector = appState.selectedDirectorWL;
    }

    //construction de la liste pour le filtre sur les réalisateurs qui s'adaptent au filtre sur le genre
    List<String> getAvailableDirectors(List<Film> films, String selectedGenre) {
      Set<String> directors = {'All'};
      for (var film in films) {
        if (selectedGenre == 'All' || film.genre.contains(selectedGenre)) {
          directors.add(film.realisateur);
        }
      }
      return directors.toList();
    }

    var realisateurs = getAvailableDirectors(filmList, selectedGenre ?? 'All');

    //meme chose pour les genres
    List<String> getAvailableGenres(List<Film> films, String selectedDirector) {
      Set<String> genres = {'All'};
      for (var film in films) {
        if (selectedDirector == 'All' || film.realisateur == selectedDirector) {
          genres.addAll(film.genre);
        }
      }
      return genres.toList();
    }

    var genres = getAvailableGenres(filmList, selectedDirector ?? 'All');

    //affichage de la page

    //si elle est vide, on affiche un message
    if (filmList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Center(child: Text(name))),
        body: Center(child: Text('No films add yet.')),
      );
    }

    return Scaffold(
      //affichage titre de la page
      appBar: AppBar(title: Center(child: Text(name))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 1, color: Colors.grey[400], height: 1),
            SizedBox(height: 10),
            //affichage des noms des filtres
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Filter by',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Genre',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Director',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            //affichage des filtres
            Row(
              children: [
                Expanded(
                  child: Container(),
                ), //laisse de la place sous le 'filter by'
                //filtre sur le genre
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGenre,
                    onChanged: (value) {
                      appState.updateGenre(
                        value!,
                        name,
                      ); //met à jour le genre seléctionner
                      realisateurs = getAvailableDirectors(
                        filmList,
                        value,
                      ); //met à jour la liste des réalisateurs à proposer
                    },
                    items:
                        genres.map((genre) {
                          return DropdownMenuItem(
                            value: genre,
                            child: Text(
                              genre,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                  ),
                ),
                //filtre sur le réalisateur
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDirector,
                    onChanged: (value) {
                      appState.updateDirector(
                        value!,
                        name,
                      ); //met à jour le réalisateur sélectionné
                      genres = getAvailableGenres(
                        filmList,
                        value,
                      ); //met à jour la liste des genres à proposer
                    },
                    items:
                        realisateurs.map((realisateur) {
                          return DropdownMenuItem(
                            value: realisateur,
                            child: Text(
                              realisateur,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
            //affichage de la liste de films
            Expanded(
              child: ListView.builder(
                itemCount: filmListFiltered.length,
                itemBuilder: (context, index) {
                  final film = filmListFiltered[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FilmPage(
                                film: film,
                              ), //quand on clique envoie sur la page détaillé du film
                        ),
                      );
                    },
                    child: Card(
                      //chaque film dans une card de meme taille
                      margin: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Container(
                        height: 120,
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              //affichage de l'image
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                'lib/assets/${film.image}',
                                fit: BoxFit.cover,
                                width: 80,
                                height: double.infinity,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              //affichage d'informations du film
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    film.titre,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    softWrap: true,
                                  ),
                                  Text("Director: ${film.realisateur}"),
                                  Text(
                                    film.genre.join(', '),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              //affichage des boutons
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(
                                    appState.likes.contains(
                                          film,
                                        ) //coloré si dans la liste des favoris
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                  onPressed:
                                      () => appState.toggleLikes(
                                        film,
                                      ), //ajout aux favoris
                                ),
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(
                                    appState.watchList.contains(film)
                                        ? Icons.watch_later
                                        : Icons.watch_later_outlined,
                                  ),
                                  onPressed:
                                      () => appState.toggleWatchList(
                                        film,
                                      ), //ajout à la WL
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

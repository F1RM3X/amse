import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'film.dart';
import '../pages/film_page.dart';

class ViewListFilm extends StatelessWidget {
  final String name;

  ViewListFilm({required this.name});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<Film> filmList = [];
    List<Film> filmListFiltered = [];
    String? selectedGenre;
    String? selectedDirector;

    if (name == 'Great Movies App') {
      filmList = appState.films;
      filmListFiltered = appState.filteredFilmsHome;
      selectedGenre = appState.selectedGenreHome;
      selectedDirector = appState.selectedDirectorHome;
    } else if (name == 'Like') {
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

    List<String> getAvailableDirectors(List<Film> films, String selectedGenre) {
      Set<String> directors = {'All'};
      for (var film in films) {
        if (selectedGenre == 'All' || film.genre.contains(selectedGenre)) {
          directors.add(film.realisateur);
        }
      }
      return directors.toList();
    }

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
    var realisateurs = getAvailableDirectors(filmList, selectedGenre ?? 'All');

    if (filmList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Center(child: Text(name))),
        body: Center(child: Text('No films add yet.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Center(child: Text(name))),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(thickness: 1, color: Colors.grey[400], height: 1),
            SizedBox(height: 10),
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
            Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGenre,
                    onChanged: (value) {
                      appState.updateGenre(value!, name);
                      realisateurs = getAvailableDirectors(filmList, value);
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
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDirector,
                    onChanged: (value) {
                      appState.updateDirector(value!, name);
                      genres = getAvailableGenres(filmList, value);
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
                          builder: (context) => FilmPage(film: film),
                        ),
                      );
                    },
                    child: Card(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(
                                    appState.likes.contains(film)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    /*color:
                                        appState.likes.contains(film)
                                            ? Colors.red
                                            : Colors.grey,*/
                                  ),
                                  onPressed: () => appState.toggleLikes(film),
                                ),
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(
                                    appState.watchList.contains(film)
                                        ? Icons.watch_later
                                        : Icons.watch_later_outlined,
                                    /*color:
                                        appState.watchList.contains(film)
                                            ? Colors.blue
                                            : Colors.grey,*/
                                  ),
                                  onPressed:
                                      () => appState.toggleWatchList(film),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/film.dart';

class MyAppState extends ChangeNotifier {
  List<Film> films = [];
  List<Film> watchList = [];
  List<Film> likes = [];
  String selectedGenreHome = 'All';
  String selectedDirectorHome = 'All';
  String selectedGenreLike = 'All';
  String selectedDirectorLike = 'All';
  String selectedGenreWL = 'All';
  String selectedDirectorWL = 'All';
  bool isLoading = true;
  String? error;

  MyAppState() {
    loadFilms();
    loadLikes();
    loadWatchList();
  }

  //chargement des films, conversion en objet Film et ajout liste films
  Future<void> loadFilms() async {
    //utilisation d'un Future car il y a un chargement (objet qui représente une valeur pas forcément dispo immédiatement)
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/assets/films.json',
      ); //chargement du json
      final List<dynamic> jsonResponse = json.decode(
        jsonString,
      ); //décodage pour qu'il soit lisible par Dart
      films =
          jsonResponse
              .map((film) => Film.fromJson(film))
              .toList(); //chaque entrée json -> objet Film et placé dans la liste films
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = 'error loading films: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadLikes() async {
    final prefs = await SharedPreferences.getInstance();
    final likesData = prefs.getString('likes');
    print("JSON brut chargé : $likesData");
    if (likesData != null) {
      print("Favoris chargés : $likesData");
      List decodedLikes = jsonDecode(likesData);
      likes = decodedLikes.map((film) => Film.fromJson(film)).toList();
      print("Liste :  $likes");
      notifyListeners();
    } else {
      print("Aucun favori trouvé");
    }
  }

  //gestion des favoris
  void toggleLikes(Film film) {
    if (likes.contains(film)) {
      likes.remove(film);
    } else {
      likes.add(film);
    }
    notifyListeners();
    saveLikes();
  }

  void saveLikes() async {
    final prefs = await SharedPreferences.getInstance();
    List likesData = likes.map((film) => film.toJson()).toList();
    prefs.setString('likes', jsonEncode(likesData));
    print("Favoris sauvegardés : ${jsonEncode(likesData)}");
  }

  void loadWatchList() async {
    final watchlist = await SharedPreferences.getInstance();
    final wlData = watchlist.getString('wl');
    if (wlData != null) {
      List decodedWL = jsonDecode(wlData);
      watchList = decodedWL.map((film) => Film.fromJson(film)).toList();
      notifyListeners();
    }
  }

  //gestion de la watchList
  void toggleWatchList(Film film) {
    if (watchList.contains(film)) {
      watchList.remove(film);
    } else {
      watchList.add(film);
    }
    notifyListeners();
    saveWL();
  }

  void saveWL() async {
    final watchlist = await SharedPreferences.getInstance();
    List wlData = watchList.map((film) => film.toJson()).toList();
    watchlist.setString('wl', jsonEncode(wlData));
  }

  void updateGenre(String genre, String page) {
    if (page == 'Great Movies App') {
      selectedGenreHome = genre;
      notifyListeners();
    } else if (page == 'Like') {
      selectedGenreLike = genre;
      notifyListeners();
    } else if (page == 'WatchList') {
      selectedGenreWL = genre;
      notifyListeners();
    }
  }

  void updateDirector(String director, String page) {
    if (page == 'Great Movies App') {
      selectedDirectorHome = director;
      notifyListeners();
    } else if (page == 'Like') {
      selectedDirectorLike = director;
      notifyListeners();
    } else if (page == 'WatchList') {
      selectedDirectorWL = director;
      notifyListeners();
    }
  }

  List<Film> get filteredFilmsHome {
    return films.where((film) {
      final genreMatch =
          selectedGenreHome == 'All' || film.genre.contains(selectedGenreHome);
      final directorMatch =
          selectedDirectorHome == 'All' ||
          film.realisateur.toLowerCase().trim() ==
              selectedDirectorHome.toLowerCase().trim();
      return genreMatch && directorMatch;
    }).toList();
  }

  List<Film> get filteredFilmsLike {
    return likes.where((film) {
      final genreMatch =
          selectedGenreLike == 'All' || film.genre.contains(selectedGenreLike);
      final directorMatch =
          selectedDirectorLike == 'All' ||
          film.realisateur.toLowerCase().trim() ==
              selectedDirectorLike.toLowerCase().trim();
      return genreMatch && directorMatch;
    }).toList();
  }

  List<Film> get filteredFilmsWL {
    return watchList.where((film) {
      final genreMatch =
          selectedGenreWL == 'All' || film.genre.contains(selectedGenreWL);
      final directorMatch =
          selectedDirectorWL == 'All' ||
          film.realisateur.toLowerCase().trim() ==
              selectedDirectorWL.toLowerCase().trim();
      return genreMatch && directorMatch;
    }).toList();
  }
}

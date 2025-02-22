import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/film.dart';


class MyAppState extends ChangeNotifier {
  List<Film> films=[];
  List<Film> watchList=[];
  List<Film> likes=[];
  String selectedGenreHome = 'All';
  String selectedDirectorHome= 'All';
  String selectedGenreLike = 'All';
  String selectedDirectorLike= 'All';
  String selectedGenreWL = 'All';
  String selectedDirectorWL= 'All';
  bool isLoading = true;
  String? error;

  MyAppState(){
    loadFilms();
  }

    //chargement des films, conversion en objet Film et ajout liste films
  Future<void> loadFilms() async{ //utilisation d'un Future car il y a un chargement (objet qui représente une valeur pas forcément dispo immédiatement)
    try{
      final String jsonString = await rootBundle.loadString('lib/assets/films.json');//chargement du json
      final List<dynamic> jsonResponse = json.decode(jsonString);//décodage pour qu'il soit lisible par Dart
      films = jsonResponse.map((film)=> Film.fromJson(film)).toList();//chaque entrée json -> objet Film et placé dans la liste films
      isLoading= false;
      notifyListeners();
    }
    catch (e) {
      error= 'error loading films: $e';
    }
    finally{
      isLoading= false;
      notifyListeners();
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
  }

  //gestion de la watchList
  void toggleWatchList(Film film) {
    if (watchList.contains(film)) {
      watchList.remove(film);
    } else {
      watchList.add(film);
    }
    notifyListeners();
  }

  void updateGenre (String genre, String page){
    if (page == 'Home'){
    selectedGenreHome= genre;
    notifyListeners();
    }
    else if (page == 'Like'){
    selectedGenreLike= genre;
    notifyListeners();
    }
    else if (page == 'WL'){
    selectedGenreWL= genre;
    notifyListeners();
    }
  }

  void updateDirector (String director, String page){
    if (page=='Home'){
    selectedDirectorHome= director;
    notifyListeners();
  }
  else if (page=='Like'){
    selectedDirectorLike= director;
    notifyListeners();
  }
  else if (page=='WL'){
    selectedDirectorWL= director;
    notifyListeners();
  }
  }
  


  List<Film> get filteredFilmsHome{
    return films.where((film){
      final genreMatch = selectedGenreHome == 'All' || film.genre.contains(selectedGenreHome);
      final directorMatch = selectedDirectorHome == 'All' || film.realisateur.toLowerCase().trim==selectedDirectorHome.toLowerCase().trim;
      return genreMatch && directorMatch;
    }).toList();
  }

  List<Film> get filteredFilmsLike{
    return likes.where((film){
      final genreMatch = selectedGenreLike == 'All' || film.genre.contains(selectedGenreLike);
      final directorMatch = selectedDirectorLike == 'All' || film.realisateur.toLowerCase().trim==selectedDirectorLike.toLowerCase().trim;
      return genreMatch && directorMatch;
    }).toList();
  }

  List<Film> get filteredFilmsWL{
    return watchList.where((film){
      final genreMatch = selectedGenreWL == 'All' || film.genre.contains(selectedGenreWL);
      final directorMatch = selectedDirectorWL == 'All' || film.realisateur.toLowerCase().trim==selectedDirectorWL.toLowerCase().trim;
      return genreMatch && directorMatch;
    }).toList();
  }

}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/film.dart';


class MyAppState extends ChangeNotifier {
  List<Film> films=[];
  List<Film> watchList=[];
  List<Film> likes=[];
  String selectedGenre = 'All';
  String selectedDirector= 'All';
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

  void updateGenre (String genre){
    selectedGenre= genre;
    notifyListeners();
  }

  void updateDirector (String director){
    selectedDirector= director;
    notifyListeners();
  }

  List<Film> get filteredFilms{
    return films.where((film){
      final genreMatch = selectedGenre == 'All' || film.genre.contains(selectedGenre);
      final directorMatch = selectedDirector == 'All' || film.realisateur.toLowerCase().trim==selectedDirector.toLowerCase().trim;
      return genreMatch && directorMatch;
    }).toList();
  }

}

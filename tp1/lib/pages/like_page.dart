import 'package:flutter/material.dart';
import '../models/view_list_film.dart';

class LikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var nomPage = 'Likes';
    //appel pour construire la page
    return ViewListFilm(name: nomPage);
  }
}

import 'package:flutter/material.dart';
import '../models/view_list_film.dart';

class WatchListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var nomPage = 'WatchList';
    //appel pour construire la page
    return ViewListFilm(name: nomPage);
  }
}

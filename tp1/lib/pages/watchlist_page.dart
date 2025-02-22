import 'package:flutter/material.dart';
import '../models/view_list_film.dart';

class WatchListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var nomPage = 'WatchList';

    return ViewListFilm(name: nomPage);
  }
}
    
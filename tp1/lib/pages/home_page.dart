import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/view_list_film.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var nomPage = 'Great Movies App';

    if (appState.isLoading) {
      //en attente du chargement
      return const Center(child: CircularProgressIndicator());
    }

    //appel pour construire la page

    return ViewListFilm(name: nomPage);
  }
}

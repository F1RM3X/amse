import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/view_list_film.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();
    var nomPage = 'Home';

    if (appState.isLoading){
      return const Center(
        child: CircularProgressIndicator()
        );
    }

    

    return ViewListFilm(name: nomPage);
  }
}
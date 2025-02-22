import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';


class LikePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.likes.isEmpty) {
      return Center(
        child: Text('No liked films yet.'),
      );
    }

    return ListView.builder(
      itemCount: appState.likes.length,
      itemBuilder: (context, index){
        final film= appState.likes[index];
        return ListTile(
          leading: Image.asset('lib/assets/${film.image}', width: 50) ,
          title: Text(film.titre)
          );
      }
    );
  }    
} 
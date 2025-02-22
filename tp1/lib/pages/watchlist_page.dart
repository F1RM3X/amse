import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class WatchListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.watchList.isEmpty) {
      return Center(
        child: Text('No films add yet.'),
      );
    }

    return ListView.builder(
      itemCount: appState.watchList.length,
      itemBuilder: (context, index){
        final film= appState.watchList[index];
        return ListTile(
          leading: Image.asset('lib/assets/${film.image}', width: 50) ,
          title: Text(film.titre)
          );
      }
    );
  }    
}
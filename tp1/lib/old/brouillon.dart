/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:tp1/essai.dart';
import 'film.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Movie List',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 32, 65, 109)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Film> films= [];
  bool isLoading= true;
  String? error;
  MyAppState(){
    loadFilms();
  }

  Future<void> loadFilms() async {
  try {
    // 1️⃣ Chargement du fichier JSON depuis les assets
    final String jsonString = await rootBundle.loadString('assets/films.json');

    // 2️⃣ Décodage du JSON en une structure lisible par Dart
    final List<dynamic> jsonResponse = json.decode(jsonString);

    // 3️⃣ Conversion de chaque entrée JSON en un objet Film
    films = jsonResponse.map((film) => Film.fromJson(film)).toList();
  } catch (e) {
    // 4️⃣ Gestion des erreurs lors du chargement ou du parsing
    error = 'Erreur lors du chargement des films: $e';
  } finally {
    // 5️⃣ Mise à jour de l'état et notification des widgets écoutant cet état
    isLoading = false;
    notifyListeners();
  }
}

  /*void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }*/
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  var selectedIndex=0;
  
  int currentIndex=0;
  actualiser(int index){
    setState((){
      currentIndex=index;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

    Widget page;
switch (currentIndex) {
  case 0:
    page = GeneratorPage();
    break;
  case 1:
    page = LikePage();
    break;
  default:
    throw UnimplementedError('no widget for $selectedIndex');
}
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index)=>{
              actualiser(index)

            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Accueil"
                ),

                BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: "Favoris"
                ),
            ],
            
          ),

                    
          body: Row(
            children: [
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class LikePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}











class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        // ↓ Change this line.
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}*/
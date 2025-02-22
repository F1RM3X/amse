import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
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
        title: 'Great Movies App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 182, 43)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Film> films=[];
  List<Film> watchList=[];
  List<Film> likes=[];
  bool isLoading = true;

  MyAppState(){
    loadFilms();
  }

  //chargement des films, conversion en objet Film et ajout liste films
  Future<void> loadFilms() async{ //utilisation d'un Future car il y a un chargement (objet qui représente une valeur pas forcément dispo immédiatement)
    final String jsonString = await rootBundle.loadString('assets/films.json');//chargement du json
    final List<dynamic> jsonResponse = json.decode(jsonString);//décodage pour qu'il soit lisible par Dart
    films = jsonResponse.map((film)=> Film.fromJson(film)).toList();//chaque entrée json -> objet Film et placé dans la liste films
    isLoading= false;
    notifyListeners();
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

}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    //changement de pages
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      /*case 1:
        page = LikePage();
        break;
      case 2:
        page = WatchListPage();*/
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      //barre de navigation
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Likes'),
          BottomNavigationBarItem(icon: Icon(Icons.watch_later), label: 'WatchList'),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
        },
        ),
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    var appState = context.watch<MyAppState>();

    if (appState.isLoading){
      return const Center(
        child: CircularProgressIndicator()
        );
    }

    return ListView.builder(
      itemCount: appState.films.length,
      itemBuilder: (context, index){
        final film = appState.films[index];
        return ListTile(
          leading: Image.asset('assets/${film.image}', width: 50),
          title: Text(film.titre),
          subtitle: Text('${film.realisateur} - ${film.genre.join(',')}'),
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> FilmPage(film:film)),
              );
          },
          );

      },
    );
  }
}

class FilmPage extends StatelessWidget{
  final Film film;

  FilmPage({
    required this.film
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isLiked = appState.likes.contains(film);
    bool inWatchList = appState.watchList.contains(film);

    return Scaffold(
      appBar: AppBar(title: Text(film.titre)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset('assets/${film.image}'),
            SizedBox(height: 10),
            Text(film.resume),
            SizedBox(height: 10),
            Text('Director: ${film.realisateur}'),
            Text('Duration: ${film.duree}'),
            Text('Genre: ${film.genre.join(', ')}'),
            Text('Rating: ${film.note}/10'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                  onPressed: () {
                    appState.toggleLikes(film);
                  },
                ),
                IconButton(
                  icon: Icon(inWatchList ? Icons.watch_later : Icons.watch_later_outlined),
                  onPressed: () {
                    appState.toggleWatchList(film);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

    
}

    /*return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,  // ← Here.
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}*/

/*class FavoritesPage extends StatelessWidget{
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

} */


/*class GeneratorPage extends StatelessWidget {
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
}*/

/*class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      //backgroundColor: Color.fromRGBO(0,0,255,1.0)
        
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation:0.0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }*/

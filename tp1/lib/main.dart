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
      final String jsonString = await rootBundle.loadString('assets/films.json');//chargement du json
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
      case 1:
        page = LikePage();
        break;
      case 2:
        page = WatchListPage();
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

    final genres = ['All'];
    for ( var film in appState.films){
      for (var genre in film.genre){
        if (genres.contains(genre)==false){
          genres.add(genre);
        }
      }
    }

    final realisateurs = ['All'];
    for ( var film in appState.films){
        if (realisateurs.contains(film.realisateur)== false){
          realisateurs.add(film.realisateur);
        }
      
    }






    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: appState.selectedGenre,
                  onChanged: (value)=> appState.updateGenre(value!),
                  items: genres.map((genre){
                    return DropdownMenuItem(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                  ),
              ),
              const SizedBox(width: 10),
               Expanded(
                child: DropdownButton<String>(
                  value: appState.selectedDirector,
                  onChanged: (value)=> appState.updateDirector(value!),
                  items: realisateurs.map((realisateur){
                    return DropdownMenuItem(
                      value: realisateur,
                      child: Text(realisateur),
                    );
                  }).toList(),
                  ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: appState.filteredFilms.length,
            itemBuilder: (context, index){
              final film = appState.filteredFilms[index];
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
          ),
        ),
      ],
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
          leading: Image.asset('assets/${film.image}', width: 50) ,
          title: Text(film.titre)
          );
      }
    );
  }    
} 

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
          leading: Image.asset('assets/${film.image}', width: 50) ,
          title: Text(film.titre)
          );
      }
    );
  }    
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'pages/home_page.dart';
import 'pages/like_page.dart';
import 'pages/watchlist_page.dart';
import 'pages/about_page.dart';

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



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
final theme = Theme.of(context);

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
        break;
      case 3:
        page= AboutPage();
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
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About')
        ],
        
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.secondary,
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
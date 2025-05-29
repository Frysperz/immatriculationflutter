import 'package:flutter/material.dart';
import 'package:immatriculationflutter/pages/group_page.dart';
import 'package:immatriculationflutter/pages/home_page.dart';
import 'package:immatriculationflutter/pages/add_plaque.dart';
import 'package:immatriculationflutter/pages/players.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:immatriculationflutter/pages/rules_page.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
} 

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: [
            Text("Plaques"),
            Text("Joueurs"), 
            Text("Nouvelle Plaque"),
            Text(""),
            Text("Groupes")
          ][_currentIndex], 
        ),
        body: [
          HomePage(),
          Players(),
          AddPlaque(),
          RulesPage(),
          GroupPage()
        ][_currentIndex], 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index), 
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue, 
          unselectedItemColor: Colors.grey,
          iconSize: 32,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil'
            ), 
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Joueurs'
            ), 
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajout'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Règles'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.pageview),
                label: 'Groupes'
            ),
          ], 
        ), 
      ),
    );
  }
}



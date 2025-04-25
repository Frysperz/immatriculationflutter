import 'package:flutter/material.dart';
import 'package:immatriculationflutter/pages/home_page.dart';
import 'package:immatriculationflutter/pages/add_plaque.dart';
import 'package:immatriculationflutter/pages/players.dart';

void main() {
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
        appBar: AppBar(
          title: [
            Text("Dernière Plaque"), 
            Text("Joueurs"), 
            Text("Nouvelle Plaque")
          ][_currentIndex], 
        ),
        body: [
          HomePage(),
          Players(), 
          AddPlaque() 
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
              icon: Icon(Icons.calendar_month),
              label: 'Joueurs'
            ), 
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ajout'
            ), 
          ], 
        ), 
      ),
    );
  }
}



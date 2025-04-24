import 'package:flutter/material.dart';
import 'package:immatriculationflutter/pages/home_page.dart';

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
          title: Text("Dernière Plaque"), 
        ),
        body: [
          HomePage(),
          Players()
        ][_currentIndex], 
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index), 
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
          ], 
        ), 
      ),
    );
  }
}



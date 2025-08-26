import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immatriculationflutter/main.dart';
import 'package:immatriculationflutter/pages/home_page.dart';
import 'package:immatriculationflutter/pages/add_plaque.dart';
import 'package:immatriculationflutter/pages/players.dart';
import 'package:immatriculationflutter/pages/rules_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPage extends StatefulWidget {
  final DocumentReference<Object?> groupeRef;
  const AppPage({ super.key, required this.groupeRef });

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> showLogoutConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voulez-vous vous déconnecter?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Retour'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // TextButton(
            //   child: const Text('Non', style: TextStyle(color: Colors.red,),),
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyApp()));
            //   },
            // ),
            TextButton(
              child: const Text('Oui', style: TextStyle(color: Colors.red,),),
              onPressed: () async {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(duration: Duration(seconds: 1), content: Text("Suppression des données en cours..."))
                // );
                SharedPreferences preferences = await SharedPreferences.getInstance();
                var rememberMe = preferences.getBool("remember_me") ?? false;
                if (rememberMe) {
                  await preferences.clear();
                }
                if (context.mounted) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyApp()));
                }
              },
            ),
          ],
        );
      },
    );
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
          ][_currentIndex],
          actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  showLogoutConfirmation();
                },
              ),
            ],
        ),
        body: [
          HomePage(groupeRef: widget.groupeRef),
          Players(groupeRef: widget.groupeRef),
          AddPlaque(groupeRef: widget.groupeRef),
          RulesPage(),
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
          ],
        ),
      ),
    );
  }
}




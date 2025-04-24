import 'package:flutter/material.dart';

class Players extends StatefulWidget {
  const Players({super.key});

  @override
  State<Players> createState() => _PlayersState();
} 

class _Players State extends State<Players> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des joueurs') ,
      ),
      body: Center(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("Cypcyp"),
                subtitle: Text("créateur"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("Le Bouton d'Or"),
                subtitle: Text("Challengeuse"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("La Grande & Le Jeannot Junior"),
                subtitle: Text("Parents"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("La Sisou de Papanou"),
                subtitle: Text("Voyageuse"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("Les Gauthier Juniors"),
                subtitle: Text("Quoicoubeh"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("Oncle H"),
                subtitle: Text("VVette"),
              ),
            ),
            Card(
              child: ListTile(
                leading: Image.asset("assets/images/logof.png"),
                title: Text("Le Géniteur"),
                subtitle: Text("Géniteur"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Players extends StatefulWidget {
  const Players({super.key});

  @override
  State<Players> createState() => _PlayersState();
} 

class _PlayersState extends State<Players> {

  final players = [
    {
      "pseudo": "Cypcyp", 
      "attribute": "Créateur", 
      "avatar": "logo48.png"
    },
    {
      "pseudo": "Le Bouton d'Or", 
      "attribute": "Femme à marier", 
      "avatar": "logo48.png"
    }, 
    {
      "pseudo": "La Sisou de Papanou", 
      "attribute": "Hébergeuse professionnelle", 
      "avatar": "logo48.png"
    }, 
    {
      "pseudo": "La Grande & Jeannot Junior", 
      "attribute": "Parents en devenir", 
      "avatar": "logo48.png"
    }, 
    {
      "pseudo": "Les Gauthier Junior", 
      "attribute": "Quoicoubeh", 
      "avatar": "logo48.png"
    }, 
    {
      "pseudo": "Oncle H", 
      "attribute": "VVette", 
      "avatar": "logo48.png"
    }, 
    {
      "pseudo": "Le Géniteur", 
      "attribute": "Géniteur professionnel", 
      "avatar": "logo48.png"
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des joueurs') ,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: players.length, 
          itemBuilder: (context, index) {
            final player = players[index];
            final pseudo = player['pseudo'];
            final attribute = player['attribute'];
            final avatar = player['avatar'];

            return Card(
              child: ListTile(
                leading: Image.asset("assets/images/$avatar"),
                title: Text("$pseudo"),
                subtitle: Text("$attribute"),
                trailing: Icon(Icons.more_vert),
              ),
            );
          },
        ),
      ),
    );
  }
}
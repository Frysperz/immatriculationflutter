import 'package:flutter_podium/flutter_podium.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Players extends StatefulWidget {
  const Players({super.key});

  @override
  State<Players> createState() => _PlayersState();
} 

class _PlayersState extends State<Players> {

  final _formKey = GlobalKey<FormState>();

  final playerNameController = TextEditingController();
  final attributeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    playerNameController.dispose();
    attributeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.emoji_events)),
              Tab(icon: Icon(Icons.add))
            ],
          ),
        ),
        body: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Players").orderBy('points', descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return Text("Aucun joueur");
              }

              List<dynamic> players = [];
              for (var element in snapshot.data!.docs) {
                players.add(element);
              }

              final firstPlayer = players[0];
              final avatarFirstPlayer = firstPlayer['avatar'];
              final pseudoFirstPlayer = firstPlayer['pseudo'];
              final pointsFirstPlayer = firstPlayer['points'];
              final secondPlayer = players[1];
              final avatarSecondPlayer = secondPlayer['avatar'];
              final pseudoSecondPlayer = secondPlayer['pseudo'];
              final pointsSecondPlayer = secondPlayer['points'];
              final thirdPlayer = players[2];
              final pseudoThirdPlayer = thirdPlayer['pseudo'];
              final pointsThirdPlayer = thirdPlayer['points'];
              final avatarThirdPlayer = thirdPlayer['avatar'];


              return TabBarView(
                children: <Widget>[
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        final pseudo = player['pseudo'];
                        final attribute = player['attribute'];
                        final avatar = player['avatar'];
                        final points = player['points'];

                        return Card(
                          child: ListTile(
                            leading: Image.asset("assets/images/$avatar"),
                            title: Center(child: Text("$pseudo")),
                            subtitle: Center(child: Text("$attribute")),
                            trailing: Text("$points",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.pink
                            ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Podium(
                          firstPosition: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.asset("assets/images/$avatarFirstPlayer", height: 100, width: 100)
                              ),
                              Text(pseudoFirstPlayer),
                              Text("$pointsFirstPlayer",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink
                              ),)
                            ],
                          ),
                          secondPosition: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.asset("assets/images/$avatarSecondPlayer", height: 100, width: 100)
                              ),
                              Text(pseudoSecondPlayer),
                              Text("$pointsSecondPlayer",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink
                              ),)
                            ],
                          ),
                          thirdPosition: Column(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: Image.asset("assets/images/$avatarThirdPlayer", height: 100, width: 100)
                              ),
                              Center(child: Text(pseudoThirdPlayer)),
                              Text("$pointsThirdPlayer",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink
                              ),
                              )
                            ],
                          ),
                          color: Colors.pink,
                          rankingTextColor: Colors.white,
                          showRankingNumberInsteadOfText: true,
                          rankingFontSize: 30,
                          hideRanking: false,
                          height: 150,
                          width: 100,
                          horizontalSpacing: 3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Nouveau Joueur',
                                hintText: 'Juste Leblanc',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Il faut entrer un nom";
                                }
                                return null;
                              },
                              controller: playerNameController,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description du joueur',
                                hintText: 'Auteur du petit cheval de manege',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Il faut entrer une description";
                                }
                                return null;
                              },
                              controller: attributeController,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()){
                                    final playerName = playerNameController.text;
                                    final attribute = attributeController.text;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Envoi en cours..."))
                                    );
                                    FocusScope.of(context).requestFocus(FocusNode());

                                    // ajout dans la base de donnees
                                    CollectionReference playersRef = FirebaseFirestore.instance.collection("Players");
                                    playersRef.add({
                                      'attribute': attribute,
                                      'pseudo': playerName,
                                      'points': 0,
                                      'avatar': "cypcyp.png"
                                    });
                                  }
                                },
                                child: Text("Envoyer")
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } ,
          ),
        ),
      ),
    );
  }
}
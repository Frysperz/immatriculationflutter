import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_podium/flutter_podium.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Players extends StatefulWidget {
  final DocumentReference<Object?> groupeRef;
  const Players({super.key, required this.groupeRef});

  @override
  State<Players> createState() => _PlayersState();
} 

class _PlayersState extends State<Players> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  final _formDeletionKey = GlobalKey<FormState>();
  final password = TextEditingController();
  late final _tabController = TabController(length: 3, vsync: this);

  final playerNameController = TextEditingController();
  final attributeController = TextEditingController();
  final errorMessage = TextEditingController();

  String selectedProfilePicture = 'cat';

  Future<void> showDeletionConfirmation(player, BuildContext parentContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression ?'),
          content: Container(
            margin: EdgeInsets.all(5),
            child: Form(
              key: _formDeletionKey,
              child: TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'mot de passe',
                  hintText: 'password123',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Il faut entrer un mot de passe";
                  }
                  return null;
                },
                controller: password,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retour'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer', style: TextStyle(color: Colors.red,),),
              onPressed: () {
                if (_formDeletionKey.currentState!.validate()){
                  final motdepasse = password.text;
                  password.clear();

                  if (sha256.convert(utf8.encode(motdepasse)).toString() != '775f01022bf4d207a507322d31bb010d731e96abd2e0c0a764f55ddf1f93c9c5') {
                    Navigator.of(context).pop();
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(duration: Duration(seconds: 1), content: Text("Suppression en cours..."))
                  );
                  FocusScope.of(context).requestFocus(FocusNode());

                  // suppression dans la base de donnees
                  // final groupeRef = FirebaseFirestore.instance.collection('Groupes');
                  // groupeRef
                  //     .doc('GTHR040203')
                  //     .collection("Players")
                  //     .doc(player.id)
                  //     .delete();
                  widget.groupeRef.collection("Players").doc(player.id).delete();

                  Navigator.of(context).pop();
                  Navigator.of(parentContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showPlayerData(player) async {
    Timestamp? firstPlaque;
    try {
      firstPlaque = player["first_plaque"];
    } catch (e) {
      firstPlaque = null;
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(player['pseudo']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(
                  "assets/images/${player['avatar']}",
                  width: 120,
                  height: 120,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text('Inscrit le ${DateFormat.yMMMMd('fr_CA').format(player['join_date'].toDate())}.'),
                if (firstPlaque != null) Text('Première plaque trouvée le ${DateFormat.MMMMd('fr_CA').format(player['first_plaque'].toDate())}.'),
                // Text('Le ${DateFormat.MMMMd('fr_CA').format(plaque.date.toDate())}\n'),
                Text('Description : ${player['description']}.'),
                Text('Points : ${player['points']}.'),

                // final Timestamp timestamp = plaque['date'];
                // final date = DateFormat.MMMMd('fr_CA').format(timestamp.toDate());
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retour', style: TextStyle(color: Colors.blue),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer', style: TextStyle(color: Colors.red),),
              onPressed: () {
                showDeletionConfirmation(player, context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    playerNameController.dispose();
    attributeController.dispose();
    errorMessage.dispose();
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
            controller: _tabController,
            tabs: <Widget>[
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.emoji_events)),
              Tab(icon: Icon(Icons.add))
            ],
          ),
        ),
        body: Center(
          child: StreamBuilder(
            // stream: FirebaseFirestore.instance.collection('Groupes').doc('GTHR040203').collection("Players").orderBy(
            //     'points', descending: true).snapshots(),
            stream: widget.groupeRef.collection("Players").orderBy(
                'points', descending: true).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
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
              // final secondPlayer = players[1];
              final secondPlayer = players[min(players.length - 1,1)];
              final avatarSecondPlayer = secondPlayer['avatar'];
              final pseudoSecondPlayer = secondPlayer['pseudo'];
              final pointsSecondPlayer = secondPlayer['points'];
              // final thirdPlayer = players[2];
              final thirdPlayer = players[min(players.length - 1, 2)];
              final pseudoThirdPlayer = thirdPlayer['pseudo'];
              final pointsThirdPlayer = thirdPlayer['points'];
              final avatarThirdPlayer = thirdPlayer['avatar'];


              return TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];

                        return GestureDetector(
                          onTap: () => showPlayerData(player),
                          child: Card(
                            child: ListTile(
                              leading: Image.asset("assets/images/${player['avatar']}"),
                              title: Center(child: Text("${player['pseudo']}")),
                              // subtitle: Center(child: Text("${player['attribute']}")),
                              trailing: Text("${player['points']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.pink
                                    ),
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
                                  child: Image.asset(
                                      "assets/images/$avatarFirstPlayer",
                                      height: 100, width: 100)
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
                                  child: Image.asset(
                                      "assets/images/$avatarSecondPlayer",
                                      height: 100, width: 100)
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
                                  child: Image.asset(
                                      "assets/images/$avatarThirdPlayer",
                                      height: 100, width: 100)
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
                            child: Focus(
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
                              onFocusChange: (hasFocus) {
                                if (hasFocus) {
                                  errorMessage.text = '';
                                }
                              },
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
                          DropdownButtonFormField(
                              items: const [
                                DropdownMenuItem(value: 'bird', child: Text("Oiseau")),
                                DropdownMenuItem(value: 'cat', child: Text("Chat")),
                                DropdownMenuItem(value: 'dog', child: Text("Chien")),
                                DropdownMenuItem(value: 'duck', child: Text("Canard")),
                                DropdownMenuItem(value: 'fox', child: Text("Renard")),
                                DropdownMenuItem(value: 'lion', child: Text("Lion")),
                                DropdownMenuItem(value: 'mouse', child: Text("Souris")),
                                DropdownMenuItem(value: 'penguin', child: Text('Pingouin')),
                                DropdownMenuItem(value: 'platipus', child: Text("Ornithorynque")),
                                DropdownMenuItem(value: 'rabbit', child: Text("Lapin")),
                                DropdownMenuItem(value: 'shark', child: Text("Requin"))
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder()
                              ),
                              value: selectedProfilePicture,
                              onChanged: (value) {
                                setState(() {
                                  selectedProfilePicture = value!;
                                });
                              }
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final playerName = playerNameController
                                        .text;
                                    final attribute = attributeController.text;

                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     const SnackBar(
                                    //         content: Text("Envoi en cours..."))
                                    // );
                                    // FocusScope.of(context).requestFocus(
                                    //     FocusNode());

                                    // ajout dans la base de donnees
                                    // CollectionReference playersRef = FirebaseFirestore
                                    //     .instance.collection('Groupes').doc('GTHR040203').collection("Players");
                                    CollectionReference playersRef = widget.groupeRef.collection("Players");
                                    // playersRef.add({
                                    //   'description': attribute,
                                    //   'pseudo': playerName,
                                    //   'join_date' : DateTime.now(),
                                    //   'points': 0,
                                    //   'avatar': "$selectedProfilePicture.jpeg"
                                    // });
                                    playersRef.doc(playerName).get().then((DocumentSnapshot doc) {
                                      if (!doc.exists) {
                                        playersRef.doc(playerName).set({
                                          'description': attribute,
                                          'pseudo': playerName,
                                          'join_date' : DateTime.now(),
                                          'points': 0,
                                          'avatar': "$selectedProfilePicture.jpeg"
                                        });

                                        _tabController.index = 0;
                                      }
                                      else {
                                        errorMessage.text = "Nom d'utilisateur existant.";
                                        setState(() {});
                                      }
                                    });

                                  }
                                },
                                child: Text("Envoyer")
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          Text(errorMessage.text, style: TextStyle(color: Colors.red),),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

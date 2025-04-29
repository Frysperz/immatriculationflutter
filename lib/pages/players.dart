import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Players extends StatefulWidget {
  const Players({super.key});

  @override
  State<Players> createState() => _PlayersState();
} 

class _PlayersState extends State<Players> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.emoji_events)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Players").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snapshot.hasData) {
                    return Text("Aucun joueur");
                  }

                  List<dynamic> players = [];
                  snapshot.data!.docs.forEach((element) {
                    players.add(element);
                  });

                  return Center(
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
                          ),
                        );
                      },
                    ),
                  );
                } ,
              ),
            ),
            Center(child: Text("It's rainy here")),
          ],
        ),
      ),
    );
  }
}
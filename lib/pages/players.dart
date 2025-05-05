import 'package:flutter_podium/flutter_podium.dart';
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
                    child: Expanded(
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
                              title: Text("$pseudo"),
                              subtitle: Text("$attribute"),
                              trailing: Text("$points"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 320,
                          width: double.infinity,
                          child: Podium(
                            firstPosition: Column(
                              children: [
                                Image.asset("assets/images/$avatarFirstPlayer"),
                                Text(pseudoFirstPlayer),
                                Text("$pointsFirstPlayer")
                              ],
                            ),
                            secondPosition: Column(
                              children: [
                                Image.asset("assets/images/$avatarSecondPlayer"),
                                Text(pseudoSecondPlayer),
                                Text("$pointsSecondPlayer")
                              ],
                            ),
                            thirdPosition: Column(
                              children: [
                                Image.asset("assets/images/$avatarThirdPlayer"),
                                Text(pseudoThirdPlayer),
                                Text("$pointsThirdPlayer")
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
                        ),
                      ],
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
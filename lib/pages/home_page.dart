import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Widget makePlaque(String plaqueName, double width, double height) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: height/2.5, height: height, child: Image.asset("assets/images/logof.png")),
              SizedBox(
                width: width,
                height: 0.9 * height,
                child: ColoredBox(
                  color: Colors.black12,
                  child: Center(
                    child: Text(plaqueName,
                        style: TextStyle(
                            fontSize: height/1.6,
                            fontFamily: 'bebas'
                        )
                    ),
                  ),
                ),
              ),
              SizedBox(width: height/2.5, height: height, child: Image.asset("assets/images/logo48.png")),
            ],
          ),
        )
    );
  }

  ListView listPlaques(List<dynamic> plaques) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: min(plaques.length - 1, 10),
      itemBuilder: (_, index) {
        final plaque = plaques[index + 1];
        final plaqueName = plaque['plaque'];
        final player = plaque['player'];
        final type = plaque['type'];
        final Timestamp timestamp = plaque['date'];
        final date = DateFormat.MMMMd('fr_CA').format(timestamp.toDate());

        return makePlaque(plaqueName, 140, 50);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Plaques").orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Text("Aucune Plaque");
          }

          List<dynamic> plaques = [];
          for (var element in snapshot.data!.docs) {
            plaques.add(element);
          }

          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15),
                  child: Text("Derniere Plaque",
                    style: TextStyle(
                    fontSize: 25
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              makePlaque(plaques[0]['plaque'], 250, 100),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Text("Plaques recentes",
                    style: TextStyle(
                      fontSize: 25
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              listPlaques(plaques),
            ],
          );
        } ,
      ),
    );
  }
}

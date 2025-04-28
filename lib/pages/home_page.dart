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
          snapshot.data!.docs.forEach((element) {
            plaques.add(element);
          });

          return ListView.builder(
            itemCount: plaques.length,
            itemBuilder: (context, index) {
              final plaque = plaques[index];
              final plaqueName = plaque['plaque'];
              final player = plaque['player'];
              final type = plaque['type'];
              final Timestamp timestamp = plaque['date'];
              final date = DateFormat.MMMMd('fr_CA').format(timestamp.toDate());

              return  Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 20, height: 50, child: Image.asset("assets/images/logof.png")),
                      SizedBox(
                        width: 140,
                        height: 45,
                        child: ColoredBox(
                          color: Colors.black12,
                          child: Center(
                            child: Text("$plaqueName",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: 'bebas'
                                )
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20, height: 50, child: Image.asset("assets/images/logo48.png")),
                    ],
                  ),
                )
              );
            },
          );
        } ,
      ),
    );
  }
}

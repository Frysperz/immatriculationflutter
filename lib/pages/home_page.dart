import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immatriculationflutter/models/plaque_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _formKey = GlobalKey<FormState>();
  final password = TextEditingController();

  final pointsPlaques = {
    "Récente classique" : 1,
    "Récente rare" : 3,
    "Récente légendaire" : 10,
    "Quadruplet" : 5,
    "Quadruplet légendaire" : 10,
    "Palindrome" : 3
  };

  final playersIds = {
    "La Sisou de Papanou" : "6vEwm61Sq7XfWgBOwXR6",
    "Les Gauthier Juniors": "IgEC2hYaxCKhJfSmTc0A",
    "Le Géniteur" : "OmCp4pnwqhN4zDcHyAfF",
    "Lily" : "gkrBFplwSOB3bsQdGnIj",
    "Cypcyp" : "iyWdqEUScwdMY1KfJAU5",
    "Le Bouton d'Or" : "mMnH2OdDlhUnhdPzT1wm",
    "VVette" : "ok1Ufk6C553qonNOssCO",
    "La Grande & Jeannot Junior" : "uNJiF4HD9vNoETIeVFmf"
  };


  Future<void> showDeletionConfirmation(Plaque plaque, BuildContext parentContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression ?'),
          content: Container(
            margin: EdgeInsets.all(5),
            child: Form(
              key: _formKey,
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
                if (_formKey.currentState!.validate()){
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
                  final plaquesRef = FirebaseFirestore.instance.collection('Plaques');
                  plaquesRef
                      .doc(plaque.id) // <-- Doc ID to be deleted.
                      .delete();
                  // suppression des points associés dans la base de donnees
                  final playerRef = FirebaseFirestore.instance.collection('Players').doc(playersIds[plaque.player]);
                  playerRef// <-- Doc ID to be deleted.
                      .get()
                      .then(
                        (DocumentSnapshot doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      print(data);
                      final currentPoints = data["points"];
                      print('printing current points : $currentPoints');
                      final points = {"points": currentPoints - pointsPlaques[plaque.type]};
                      print('printing final points : $points');
                      playerRef.set(points, SetOptions(merge: true));
                    },
                    onError: (e) => Text("Error getting document: $e"),
                  );

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

  Future<void> showPlaqueDetail(Plaque plaque) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true , // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(plaque.plaqueName),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Trouvée par ${plaque.player}.'),
                Text('Le ${DateFormat.MMMMd('fr_CA').format(plaque.date.toDate())}\n'),
                Text('Type : ${plaque.type}'),
                Text('Points : ${pointsPlaques[plaque.type]}.'),

                // final Timestamp timestamp = plaque['date'];
                // final date = DateFormat.MMMMd('fr_CA').format(timestamp.toDate());
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Supprimer', style: TextStyle(color: Colors.red),),
              onPressed: () {
                showDeletionConfirmation(plaque, context);
              },
            ),
          ],
        );
      },
    );
  }
  
  Widget makePlaque(Plaque plaque, double width, double height) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextButton(
            onPressed: () { showPlaqueDetail(plaque);},
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
                      child: Text(plaque.plaqueName,
                          style: TextStyle(
                            color: Colors.black,
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
        return makePlaque(plaque, 140, 50);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  void dispose() {
    super.dispose();

    password.dispose();
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

          List<Plaque> plaques = [];
          for (var data in snapshot.data!.docs) {
            plaques.add(Plaque.fromData(data, data.reference.id));
          }

          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(left: 15, bottom: 15),
                  child: Text("Dernière Plaque",
                    style: TextStyle(
                    fontSize: 25
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              makePlaque(plaques[0], 250, 100),
              SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Text("Plaques récentes",
                    style: TextStyle(
                      fontSize: 25
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                  child: listPlaques(plaques)
              ),
            ],
          );
        } ,
      ),
    );
  }
}

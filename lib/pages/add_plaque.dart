import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';

class PlaqueTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // final regEx = RegExp(r'^[A-Z]{2}[-]\d{3}[-][A-Z]{2}');
    RegExp regEx;
    switch (newValue.text.length) {
      case 0:
        regEx = RegExp(r'');
        break;
      case 1:
        regEx = RegExp(r'[a-zA-Z]');
      case 2:
        regEx = RegExp(r'[a-zA-Z]{2}');
      case 3:
        regEx = RegExp(r'[a-zA-Z]{2}-');
      case 4:
        regEx = RegExp(r'[a-zA-Z]{2}-\d');
      case 5:
        regEx = RegExp(r'[a-zA-Z]{2}-\d{2}');
      case 6:
        regEx = RegExp(r'[a-zA-Z]{2}-\d{3}');
      case 7:
        regEx = RegExp(r'[a-zA-Z]{2}-\d{3}-');
      case 8:
        regEx = RegExp(r'[a-zA-Z]{2}-\d{3}-[a-zA-Z]');
      default:
        regEx = RegExp(r'[a-zA-Z]{2}-\d{3}-[a-zA-Z]{2}');
    }
    final String newString = regEx.stringMatch(newValue.text) ?? '';
    if ((newValue.text.length == 2 || newValue.text.length == 6) && oldValue.text.length == newValue.text.length - 1) {
      return newString == newValue.text ? TextEditingValue(text: '${newValue.text}-') : oldValue;
    }
    return newString == newValue.text ? newValue : oldValue;
  }
}

class AddPlaque extends StatefulWidget {
  final DocumentReference<Object?> groupeRef;
  const AddPlaque({super.key, required this.groupeRef});

  @override
  State<AddPlaque> createState() => _AddPlaqueState();

} 

class _AddPlaqueState extends State<AddPlaque> {

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

  final pointsPlaques = {
    "Récente classique" : 1,
    "Récente rare" : 3,
    "Récente légendaire" : 10,
    "Quadruplet" : 5,
    "Quadruplet légendaire" : 10,
    "Palindrome" : 3
  };

  final _formKey = GlobalKey<FormState>();

  late FocusNode myFocusNode = FocusNode();

  final plaqueNameController = TextEditingController();
  late String selectedPlayer;
  String selectedType = 'Récente classique';
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();

    plaqueNameController.dispose();
  } 
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                // keyboardType: (plaqueNameController.text.length >= 3 && plaqueNameController.text.length <= 6) ? TextInputType.number : TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Nouvelle Plaque',
                  hintText: 'AA-123-AA',
                  border: OutlineInputBorder(),
                ),
                focusNode: myFocusNode,
                onChanged: (text) {
                  final newText = text.toUpperCase();
                  if (plaqueNameController.text != newText) {
                    plaqueNameController.value = plaqueNameController.value.copyWith(text: newText);
                  }
                  // if (plaqueNameController.text.length == 3 || plaqueNameController.text.length == 7){
                  //   myFocusNode.unfocus();
                  //   Future.delayed(const Duration(milliseconds: 50)).then((value) {
                  //     WidgetsBinding.instance.addPostFrameCallback((_) => myFocusNode.requestFocus(),);
                  //   });
                  // }
                },
                inputFormatters: [
                  PlaqueTextInputFormatter()
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Il faut entrer une plaque";
                  }
                  return null;
                },
                controller: plaqueNameController,
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(bottom: 10),
            //   child: DropdownButtonFormField(
            //     items: const [
            //       DropdownMenuItem(value: 'Cypcyp', child: Text("Cypcyp")),
            //       DropdownMenuItem(value: 'Le Bouton d\'Or', child: Text("Le Bouton d'Or")),
            //       DropdownMenuItem(value: 'La Sisou de Papanou', child: Text("La Sisou de Papanou")),
            //       DropdownMenuItem(value: 'La Grande & Jeannot Junior', child: Text("La Grande & Jeannot Junior")),
            //       DropdownMenuItem(value: 'Les Gauthier Juniors', child: Text("Les Gauthier Juniors")),
            //       DropdownMenuItem(value: 'VVette', child: Text("VVette")),
            //       DropdownMenuItem(value: 'Le Géniteur', child: Text("Le Géniteur")),
            //     ],
            //     decoration: InputDecoration(
            //       border: OutlineInputBorder()
            //     ),
            //     value: selectedPlayer,
            //     onChanged: (value) {
            //       setState(() {
            //         selectedPlayer = value!;
            //       });
            //     }
            //   ),
            // ),
            StreamBuilder(
              stream: widget.groupeRef.collection("Players").orderBy('points', descending: true).snapshots(),
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
                selectedPlayer = players[0]["pseudo"];

                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButtonFormField<String>(
                    items: players.map((data) {
                      return DropdownMenuItem<String>(
                        value: data["pseudo"],
                        child: Text(
                          data["pseudo"],
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                        border: OutlineInputBorder()
                    ),
                    value: selectedPlayer,
                    onChanged: (value) {
                      // print(value!);
                        selectedPlayer = value!;
                    },

                  ),
                );
              }
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(value: 'Récente classique', child: Text("Récente classique")),
                    DropdownMenuItem(value: 'Récente rare', child: Text("Récente rare")),
                    DropdownMenuItem(value: 'Récente légendaire', child: Text("Récente legendaire")),
                    DropdownMenuItem(value: 'Quadruplet', child: Text("Quadruplet")),
                    DropdownMenuItem(value: 'Quadruplet légendaire', child: Text("Quadruplet légendaire")),
                    DropdownMenuItem(value: 'Palindrome', child: Text("Palindrome")),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: selectedType,
                  onChanged: (value) {
                    // setState(() {
                      selectedType = value!;
                    // });
                  }
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.event_note),
                  border: OutlineInputBorder(),
                ),
                mode: DateTimeFieldPickerMode.date,
                onChanged: (DateTime? value) {
                  // setState(() {
                    selectedDate = value!;
                  // });
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    final plaqueName = plaqueNameController.text;

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("Envoi en cours..."))
                    // );
                    // FocusScope.of(context).requestFocus(FocusNode());

                    // ajout dans la base de donnees
                    // CollectionReference plaquesRef = FirebaseFirestore.instance.collection('Groupes').doc('GTHR040203').collection("Plaques");
                    CollectionReference plaquesRef = widget.groupeRef.collection("Plaques");
                    plaquesRef.add({
                      'plaque': plaqueName,
                      'player': selectedPlayer,
                      'date': selectedDate,
                      'type': selectedType
                    });

                    // CollectionReference playersRef = FirebaseFirestore.instance.collection('Groupes').doc('GTHR040203').collection("Players");
                    CollectionReference playersRef = widget.groupeRef.collection("Players");
                    // get player points before update

                    final docRef = playersRef.doc(selectedPlayer);
                    docRef.get().then(
                          (DocumentSnapshot doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final currentPoints = data["points"];
                        DateTime firstPlaque;
                        try {
                          firstPlaque = data["first_plaque"];
                        }
                        catch (e) {
                          firstPlaque = selectedDate;
                        }
                        final newdata = {
                          "points": pointsPlaques[selectedType]! + currentPoints,
                          "first_plaque": firstPlaque
                        };
                        docRef.set(newdata, SetOptions(merge: true));
                        },
                      onError: (e) => log("Error getting document: $e"),
                    );

                  }
                },
                child: Text("Envoyer")
              ),
            )
                      ],
        ),
      ),
    );
  }
}
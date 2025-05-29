import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {

  final _formKey = GlobalKey<FormState>();
  final groupId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          child: Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: 'Groupe ID',
                hintText: 'GTHR040203',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Il faut entrer un mot de passe";
                }
                return null;
              },
              controller: groupId,
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()){
                final id = groupId.text;

                FocusScope.of(context).requestFocus(FocusNode());

                // récupération du groupe dans la base de donnees
                CollectionReference groupesRef = FirebaseFirestore.instance.collection("Groupes");
                final groupeRef = groupesRef.doc(id);
                final players = groupeRef.collection("Players");
                players.add({
                  'attribute': 'Belleza',
                  'pseudo': 'Lily',
                  'avatar': 'lily.png',
                  'points': 0
                });
              }
            },
            child: Text("Envoyer")
        ),
      ],
    );
  }
}

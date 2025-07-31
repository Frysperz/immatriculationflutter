import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreationGroupPage extends StatefulWidget {
  const CreationGroupPage({super.key});

  @override
  State<CreationGroupPage> createState() => _CreationGroupPageState();
}

class _CreationGroupPageState extends State<CreationGroupPage> {

  final _formKey = GlobalKey<FormState>();

  final passwordGroupController = TextEditingController();
  final idGroupController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passwordGroupController.dispose();
    idGroupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text("Créer un groupe"),),
          body: Container(
            margin: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Groupe ID',
                        hintText: 'ABCD1234',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Il faut entrer un id de groupe.";
                        }
                        return null;
                      },
                      controller: idGroupController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'F00B@r2012',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Il faut entrer un mot de passe";
                        }
                        return null;
                      },
                      controller: passwordGroupController,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()){
                            final password = passwordGroupController.text;
                            final id = idGroupController.text;

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Création du groupe en cours..."))
                            );
                            FocusScope.of(context).requestFocus(FocusNode());

                            // ajout dans la base de donnees
                            CollectionReference groupesRef = FirebaseFirestore.instance.collection("Groupes");
                            groupesRef.doc(id).set({});
                          }
                        },
                        child: Text("Envoyer")
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

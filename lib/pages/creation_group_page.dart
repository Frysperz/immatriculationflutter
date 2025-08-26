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
  final usernameController = TextEditingController();
  final idGroupController = TextEditingController();
  String selectedAvatar = "cat";
  final descriptionController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    super.dispose();
    passwordGroupController.dispose();
    idGroupController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
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
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: '************',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            }
                        )
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
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nom du premier joueur',
                        hintText: 'Juste Leblanc',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Il faut entrer un id de groupe.";
                        }
                        return null;
                      },
                      controller: usernameController,
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
                      controller: descriptionController,
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
                      value: selectedAvatar,
                      onChanged: (value) {
                        setState(() {
                          selectedAvatar = value!;
                        });
                      }
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()){
                            final password = passwordGroupController.text;
                            final id = idGroupController.text;
                            final username = usernameController.text;
                            final description = descriptionController.text;

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Création du groupe en cours..."))
                            );
                            FocusScope.of(context).requestFocus(FocusNode());

                            // vérification de l'existence du groupe.
                            bool groupExists =(await FirebaseFirestore.instance.collection('Groupes').doc(id).get()).exists;

                            // vérification de la robustesse du mot de passe.

                            if (!groupExists) {
                              CollectionReference groupesRef = FirebaseFirestore.instance.collection("Groupes");
                              groupesRef.doc(id).set({
                                "password": password
                              });
                              FirebaseFirestore.instance.collection("Groupes").doc(id).collection("Players").add({
                                "avatar" : "$selectedAvatar.jpeg",
                                "description" : description,
                                "join_date" : DateTime.now(),
                                "points" : 0,
                                "pseudo" : username
                              });

                            }
                            else {
                              Text("Groupe déjà existant");
                            }
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

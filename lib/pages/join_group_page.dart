import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immatriculationflutter/main.dart';
import 'package:immatriculationflutter/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_page.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {

  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  final groupId = TextEditingController();
  final password = TextEditingController();
  final errorMessage = TextEditingController();
  late bool exist;
  bool _isObscure = true;

  void _handleRememberme(bool? value) {
    if (value != null) {
      _isChecked = value;
      SharedPreferences.getInstance().then(
            (prefs) {
          prefs.setBool("remember_me", value);
          prefs.setString('groupId', groupId.text);
          prefs.setString('password', password.text);
        },
      );
      setState(() {
        _isChecked = value;
      });
    }
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var group = prefs.getString("groupId") ?? "";
      var pass = prefs.getString("password") ?? "";
      var rememberMe = prefs.getBool("remember_me") ?? false;
      if (rememberMe) {
        setState(() {
          _isChecked = true;
        });
        groupId.text = group ?? "";
        password.text = pass ?? "";
      }
    } catch (e)
    {
      print(e);
    }
  }

  Future<bool> checkExistGroup(String docID) async {
    try {
      FirebaseFirestore.instance.collection("Groupes").doc(docID).get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      // If any error
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    groupId.dispose();
    password.dispose();
    errorMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Rejoindre un groupe"),),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Focus(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Groupe ID',
                          hintText: 'ABCD123456',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Il faut entrer un groupe ID";
                          }
                          return null;
                        },
                        controller: groupId,
                      ),
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          errorMessage.text = '';
                          setState(() {});
                        }
                      },
                    ),
                    Focus(
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _isObscure,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          hintText: 'Password123#',
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
                        controller: password,
                      ),
                      onFocusChange: (hasFocus) {
                        if (hasFocus) {
                          errorMessage.text = '';
                          setState(() {});
                        }
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Theme(
                            data: ThemeData(
                                unselectedWidgetColor: Color(0xff00C8E8) // Your color
                            ),
                            child: Checkbox(
                                activeColor: Color(0xff00C8E8),
                                value: _isChecked,
                                onChanged: _handleRememberme),
                          )),
                      SizedBox(width: 10.0),
                      Text("Remember Me",
                          style: TextStyle(
                              color: Color(0xff646464),
                              fontSize: 12,
                              fontFamily: 'Rubic'))
                    ])
                  ],
                ),
              ),
            ),
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()){
                    final id = groupId.text;
                    final mdp = password.text;
                    password.clear();

                    FocusScope.of(context).requestFocus(FocusNode());

                    // récupération du groupe dans la base de donnees
                    CollectionReference groupesRef = FirebaseFirestore.instance.collection("Groupes");
                    try {
                      final groupeRef = groupesRef.doc(id);
                    groupeRef.get().then((value) {
                      final motdepasse = value['password'];
                      if (motdepasse == mdp) {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => AppPage(groupeRef: groupeRef)
                            )
                        );
                      }
                      else {
                        errorMessage.text = 'Mauvais groupe ID ou mauvais mot de passe';
                        setState(() {});
                      }
                    }, onError: (error) {
                      errorMessage.text = 'Mauvais groupe ID ou mauvais mot de passe';
                      setState(() {});
                    });
                    } catch(e) {
                      errorMessage.text = "Mauvais groupe ID ou mauvais mot de passe ; $e";
                      setState(() {});
                    }
                    // try {
                    //
                    // } catch (errors) {
                    //   errorMessage.text = 'Mauvais groupe ID ou mauvais mot de passe';
                    //   setState(() {});
                    // }
                  }
                },
                child: Text("Envoyer")
            ),
            Text(errorMessage.text, style: TextStyle(color: Colors.red),),
          ],
        ),
      ),
    );
  }
}

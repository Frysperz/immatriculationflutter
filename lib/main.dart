import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immatriculationflutter/pages/app_page.dart';
import 'package:immatriculationflutter/pages/creation_group_page.dart';
import 'package:immatriculationflutter/pages/group_page.dart';
import 'package:immatriculationflutter/pages/home_page.dart';
import 'package:immatriculationflutter/pages/add_plaque.dart';
import 'package:immatriculationflutter/pages/join_group_page.dart';
import 'package:immatriculationflutter/pages/players.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:immatriculationflutter/pages/rules_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
} 

class _MyAppState extends State<MyApp> {
  //
  // int _currentIndex = 0;
  //
  // setCurrentIndex(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome()
    );
    // return MaterialApp(
    //   home: Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     appBar: AppBar(
    //       title: [
    //         Text("Plaques"),
    //         Text("Joueurs"),
    //         Text("Nouvelle Plaque"),
    //         Text(""),
    //         Text("Groupes")
    //       ][_currentIndex],
    //     ),
    //     body: [
    //       HomePage(),
    //       Players(),
    //       AddPlaque(),
    //       RulesPage(),
    //       AppPage()
    //     ][_currentIndex],
    //     bottomNavigationBar: BottomNavigationBar(
    //       currentIndex: _currentIndex,
    //       onTap: (index) => setCurrentIndex(index),
    //       type: BottomNavigationBarType.fixed,
    //       selectedItemColor: Colors.blue,
    //       unselectedItemColor: Colors.grey,
    //       iconSize: 32,
    //       elevation: 10,
    //       items: const [
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.home),
    //           label: 'Accueil'
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.person),
    //           label: 'Joueurs'
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.add),
    //           label: 'Ajout'
    //         ),
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.book),
    //             label: 'Règles'
    //         ),
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.pageview),
    //             label: 'Groupes'
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  bool _isChecked = false;

  void getGroupIfExists(context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var rememberMe = prefs.getBool("remember_me") ?? false;
      if (rememberMe) {
        setState(() {
          _isChecked = true;
        });

        var group = prefs.getString("groupId") ?? "";
        var pass = prefs.getString("password") ?? "";
        if (group != "" && pass != "") {
          DocumentReference groupeRef = FirebaseFirestore.instance.collection("Groupes").doc(group);
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_,__,___) => AppPage(groupeRef: groupeRef)
          ));
        }
      }
    } catch (e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    getGroupIfExists(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bienvenue"),),
      // body: GroupPage()
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              width: double.infinity,
              child: Text("Vous pouvez rejoindre ou créer un groupe.", textAlign: TextAlign.left,),
            ),
            Expanded(child: SizedBox()),
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.5,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        PageRouteBuilder(
                            pageBuilder: (_,__,___) => CreationGroupPage()
                        )
                    );
                  },
                  child: Text("Créer un groupe")
              ),
            ),
            SizedBox(height: 30,),
            FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.5,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_,__,___) => JoinGroupPage()
                        )
                    );
                  },
                  child: Text("Rejoindre un groupe")
              ),
            ),
            Expanded(child: SizedBox())
          ],
        ),
      ),
    );
  }
}



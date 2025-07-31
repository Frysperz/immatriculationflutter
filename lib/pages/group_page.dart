import 'package:flutter/material.dart';
import 'package:immatriculationflutter/pages/creation_group_page.dart';
import 'package:immatriculationflutter/pages/join_group_page.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
                      Navigator.push(
                          context,
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
        );
  }
}

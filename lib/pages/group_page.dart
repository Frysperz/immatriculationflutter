import 'package:flutter/material.dart';
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
          FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.5,
            child: ElevatedButton(
                onPressed: () {},
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
        ],
      ),
    );
  }
}

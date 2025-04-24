import 'package:flutter/material.dart';
import 'add_plaque.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/plaque_ex.png"),
            Text("Bienvenue a l'endroit de la derniere plaque",
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins'
              ),
              textAlign: TextAlign.center,
            ),
            Text("Plaques recentes",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit'
              ),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
          ],
        ),
      );
  }
}
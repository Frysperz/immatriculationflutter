import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(left: 15),
            width: double.infinity,
            child: Text('Explications du jeu',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.left
            )
        ),
        Container(
          margin: EdgeInsets.all(15),
          child: Text("Les plaques d'immatriculation sont éditées de façon linéaire, c'est-à-dire de la façon suivante :\n"
              "AA-001-AA -> ... -> AA-999-AA -> AA-001-AB -> AA-999-AZ -> AA-001-BA ...\n"
              "La dernière plaque sera donc la ZZ-999-ZZ.\n\n"
              "Note : Les lettres I,O et U n'existent pas dans les plaques d'immatriculations de même que la combinaison de lettres SS."),
        ),
        Container(
            margin: EdgeInsets.only(left: 15),
            width: double.infinity,
            child: Text('Règles',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.left
            )
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            // border: TableBorder.all(color: Colors.black),
            border: TableBorder(horizontalInside: BorderSide(
                width: 2, color: Colors.grey, style: BorderStyle.solid)),
            children: [
              TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Text(
                        'Récente classique', textAlign: TextAlign.left,),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'GT-',
                        style: DefaultTextStyle.of(context).style,
                        children: const <TextSpan>[
                          TextSpan(text: '402-HR', style: TextStyle(color: Colors.purple)),
                        ],
                      ),
                      textAlign : TextAlign.center,
                    ),
                    Text('1 point', textAlign: TextAlign.right,),
                  ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text('Récente rare', textAlign: TextAlign.left,),
                ),
                RichText(
                  text: TextSpan(
                    text: 'M',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'B', style: TextStyle(color: Colors.purple)),
                      TextSpan(text: '-001-AA'),
                    ],
                  ),
                  textAlign : TextAlign.center,
                ),
                // Text('MM-001-AA', textAlign: TextAlign.center,),
                Text('3 points', textAlign: TextAlign.right,),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text('Récente légendaire', textAlign: TextAlign.left,),
                ),
                RichText(
                  text: TextSpan(
                    text: 'M',
                    style: TextStyle(color: Colors.purple),
                    children: <TextSpan>[
                      TextSpan(text: 'A-001-AA', style: DefaultTextStyle.of(context).style),
                    ],
                  ),
                  textAlign : TextAlign.center,
                ),
                // Text('MA-001-AA', textAlign: TextAlign.center,),
                Text('10 points', textAlign: TextAlign.right,),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text('Palindrome', textAlign: TextAlign.left,),
                ),
                Text('AM-727-MA', textAlign: TextAlign.center,),
                Text('3 points', textAlign: TextAlign.right,),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Text('Quadruplet', textAlign: TextAlign.left,),
                ),
                Text('GG-123-GG', textAlign: TextAlign.center,),
                Text('5 points', textAlign: TextAlign.right,),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Quadruplet légendaire', textAlign: TextAlign.left,),
                ),
                Text('AA-123-AA', textAlign: TextAlign.center,),
                Text('10 points', textAlign: TextAlign.right,),
              ])
            ],
          ),
        ),
      ],
    );
  }
}
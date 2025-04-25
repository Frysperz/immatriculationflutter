import 'package:flutter/material.dart';

class AddPlaque extends StatefulWidget {
  const AddPlaque({super.key});

  @override
  State<AddPlaque> createState() => _AddPlaqueState();

} 

class _AddPlaqueState extends State<AddPlaque> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nouvelle Plaque', 
                hintText: 'AA-123-AA', 
                border: OutlineInputBorder(), 
              ), 
            ), 
            SizedBox(
              width: double.infinity, 
              height: 50,
              child: ElevatedButton(
                onPressed:, 
                child: Text("Envoyer") 
              ), 
            ) 
          ], 
        ), 
      ), 
    );
  }
}
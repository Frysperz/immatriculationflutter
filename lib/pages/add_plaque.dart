import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class AddPlaque extends StatefulWidget {
  const AddPlaque({super.key});

  @override
  State<AddPlaque> createState() => _AddPlaqueState();

} 

class _AddPlaqueState extends State<AddPlaque> {

  final _formKey = GlobalKey<FormState>();

  final plaqueNameController = TextEditingController();
  String selectedPlayer = 'Cypcyp';
  String selectedType = 'Recente classique';
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    super.dispose();

    plaqueNameController.dispose();
  } 
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey, 
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nouvelle Plaque', 
                  hintText: 'AA-123-AA', 
                  border: OutlineInputBorder(), 
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Il faut entrer une plaque";
                  }
                  return null;
                },
                controller: plaqueNameController, 
              ), 
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10), 
              child: DropdownButtonFormField(
                items: const [
                  DropdownMenuItem(value: 'Cypcyp', child: Text("Cypcyp")),
                  DropdownMenuItem(value: 'Le Bouton d\'Or', child: Text("Le Bouton d'Or")),
                  DropdownMenuItem(value: 'La Sisou de Papanou', child: Text("La Sisou de Papanou")),
                  DropdownMenuItem(value: 'La Grande & Jeannot Junior', child: Text("La Grande & Jeannot Junior")),
                  DropdownMenuItem(value: 'Les Gauthier Juniors', child: Text("Les Gauthier Juniors")),
                  DropdownMenuItem(value: 'Oncle H', child: Text("Oncle H")),
                  DropdownMenuItem(value: 'Le Géniteur', child: Text("Le Géniteur")),
                ], 
                decoration: InputDecoration(
                  border: OutlineInputBorder() 
                ), 
                value: selectedPlayer, 
                onChanged: (value) {
                  setState(() {
                    selectedPlayer = value!;
                  });
                } 
              ), 
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(value: 'Recente classique', child: Text("Recente classique")),
                    DropdownMenuItem(value: 'Recente rare', child: Text("Recente rare")),
                    DropdownMenuItem(value: 'Recente legendaire', child: Text("Recente legendaire")),
                    DropdownMenuItem(value: 'Quadruplet', child: Text("Quadruplet")),
                    DropdownMenuItem(value: 'Palindrome', child: Text("Palindrome")),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  }
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.event_note),
                  border: OutlineInputBorder(),
                ),
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedDate = value!;
                  });
                },
              ),
            ),
            SizedBox(
              width: double.infinity, 
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()){
                    final plaqueName = plaqueNameController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoi en cours...")) 
                    );
                    FocusScope.of(context).requestFocus(FocusNode());

                    // ajout dans la base de donnees
                    CollectionReference plaquesRef = FirebaseFirestore.instance.collection("Plaques");
                    plaquesRef.add({
                      'plaque': plaqueName,
                      'player': selectedPlayer,
                      'date': selectedDate,
                      'type': selectedType
                    });
                  } 
                }, 
                child: Text("Envoyer") 
              ), 
            ) 
          ], 
        ), 
      ), 
    );
  }
}
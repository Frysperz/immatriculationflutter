import 'package:flutter/material.dart';

class AddPlaque extends StatefulWidget {
  const AddPlaque({super.key});

  @override
  State<AddPlaque> createState() => _AddPlaqueState();

} 

class _AddPlaqueState extends State<AddPlaque> {

  final _formKey = GlobalKey<FormState>();

  final plaqueNameController = TextEditingController();
  String selectedPlayer = 'player1';

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
                  DropdownMenuItem(value: 'player1', child: Text("Cypcyp")),
                  DropdownMenuItem(value: 'player2', child: Text("Le Bouton d'Or")),
                   DropdownMenuItem(value: 'player3', child: Text("La Sisou de Papanou")),
                  DropdownMenuItem(value: 'player4', child: Text("La Grande & Jeannot Junior")),
                  DropdownMenuItem(value: 'player5', child: Text("Les Gauthier Juniors")),
                  DropdownMenuItem(value: 'player6', child: Text("Oncle H")),
                  DropdownMenuItem(value: 'player7', child: Text("Le Géniteur")),
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

                    print("Ajout de la plaque $plaqueName");
                    print("Plaque trouvée par $selectedPlayer");
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
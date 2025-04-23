import 'package:flutter/material.dart';

class AddPlaque extends StatelessWidget {
  const AddPlaque({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajout d\'une nouvelle plaque') ,
      ),
      body: Center(
        child: Text('Prochainement disponible'),
      ),
    );
  }
}
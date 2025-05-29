import 'package:cloud_firestore/cloud_firestore.dart';

class Plaque {
  final String plaqueName;
  final String player;
  final Timestamp date;
  final String type;
  final String id;

  Plaque({
    required this.plaqueName,
    required this.player,
    required this.date,
    required this.type,
    required this.id
  });

  factory Plaque.fromData(dynamic data, String plaqueId) {
    return Plaque(
        plaqueName: data['plaque'],
        player: data['player'],
        date: data['date'],
        type: data['type'],
        id: plaqueId
    );
  }
}
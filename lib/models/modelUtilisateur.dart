import 'dart:convert';
import 'package:http/http.dart' as http;
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';
import 'package:opharma/utils/Endpoint.dart';

class ModelUtilisateur {
  static BaseDeDonnee base = BaseDeDonnee();

  static Future<int> creation(id_utilisateurs, type_utilisateur, login, mot_de_passe) async {
    int id_utilisateur = await base.ajoutDonnees("utilisateur", {
      "id_utilisateur": id_utilisateurs,
      "type_utilisateur": type_utilisateur,
      "login": login,
      "mot_de_passe": mot_de_passe, // Correction de la faute de frappe
    });

    // Préparation des données pour l'API
    Map<String, dynamic> data = {
      "id_utilisateur": id_utilisateurs,
      "type_utilisateur": type_utilisateur,
      "login": login,
      "mot_de_passe": mot_de_passe,
    };

    // Envoi des données à l'API
    Uri url = Uri.parse(Endpoint.baseUrlEnregisterUtilisateur); // Assure-toi d'ajouter cette URL dans Endpoint.dart
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json",
      "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
      },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print("Utilisateur enregistré avec succès : ${response.body}");
      } else {
        print("Erreur lors de l'enregistrement : ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    }

    return id_utilisateur;
  }

  static Future<List> connecter(String login, String mot_de_passe, String type) async {
    print([login, mot_de_passe, type]);
    var boll = false;
    var droit = "";
    String requete = "SELECT id_utilisateur FROM utilisateur WHERE type_utilisateur='$type' AND mot_de_passe='$mot_de_passe' AND login='$login'";
    var val = await base.reccuperationDonnees(requete);

    if (val.isNotEmpty) {
      Session.id_connect = val[0]["id_utilisateur"];
      boll = true;
    }
    return [boll, droit];
  }

  static void deconnection() {
    Session.id_connect = 0;
  }
}

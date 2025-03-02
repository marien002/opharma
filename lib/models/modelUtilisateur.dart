import 'dart:convert';
import 'package:http/http.dart' as http;
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';
import 'package:opharma/utils/Endpoint.dart';

class ModelUtilisateur {
  static BaseDeDonnee base = BaseDeDonnee();

  static BaseDeDonnee base=new  BaseDeDonnee();

  int? id;
  String nom;
  String login;
  String password;

  ModelUtilisateur({this.id, required this.nom, required this.login, required this.password});
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

  // Convertir en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom_utilisateur': nom,
      'login': login,
      'password': password,
    };
  }

  // Convertir depuis Map (depuis SQLite)
  factory ModelUtilisateur.fromMap(Map<String, dynamic> map) {
    return ModelUtilisateur(
      id: map['id'],
      nom: map['nom_utilisateur'],
      login: map['login'],
      password: map['password'],
    );
  }


  static creation(ModelUtilisateur utilisateur)async {

     int id_utilisateur=await base.ajoutDonnees("utilisateur",utilisateur.toMap());
     return id_utilisateur;

    return id_utilisateur;
  }

  static connecter(String login,String mot_de_passe,String type)async {

  }



  static void deconnection() {
    Session.id_connect = 0;
  }
}

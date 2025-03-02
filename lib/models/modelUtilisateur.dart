import 'dart:convert';
import 'package:http/http.dart' as http;
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';
import 'package:opharma/utils/Endpoint.dart';

class ModelUtilisateur {


  static BaseDeDonnee base = new BaseDeDonnee();

  int? id;
  String nom;
  String login;
  String password;

  // Convertir en Map (pour SQLite)


  ModelUtilisateur(
      {this.id, required this.nom, required this.login, required this.password});
  Map<String, dynamic> toMap() {
    return {
      "nom": nom,
      "login": login,
      'password': password,
    };
  }


  static connecter(String login, String mot_de_passe, String type) async {

  }
  creation() async {
    Map<String, dynamic> data = ModelUtilisateur(nom: nom, login: login, password: password).toMap();
    Uri url = Uri.parse(Endpoint.baseUrlEnregisterpharmacie);
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json",
          "User-Agent": "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print("Données envoyées avec succès : ${response.body}");
        // Décoder la réponse
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Récupérer les nouvelles valeurs
        if (responseData["success"] == true && responseData["data"] != null) {
          Map<String, dynamic> apiData = responseData["data"];

          // Ajout dans la base locale avec les données de l'API
          int id_utilisateur = await base.ajoutDonnees("pharmacie",data);
        }
      }  else {
        print("Erreur lors de l'envoi : ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    }

    //int id_utilisateur = await base.ajoutDonnees(  "utilisateur", utilisateur.toMap());
    //return id_utilisateur;
  }

  static void deconnection() {
    Session.id_connect = 0;
  }
}

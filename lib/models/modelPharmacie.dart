import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opharma/utils/Endpoint.dart';
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';

class ModelPharmacie {
  late int? id_pharmacie;
  String nom_pharmacie;
  String adresse_physique;
  String longitude;
  String latutude;

  String nomTable = "pharmacie";
  static BaseDeDonnee base = new BaseDeDonnee();

  ModelPharmacie(this.nom_pharmacie, this.adresse_physique, this.longitude, this.latutude);

  ajouter() async {
    int? idPhar;


    // Prépare les données pour l'API
    Map<String, dynamic> data = {
      "nom_pharmacie": this.nom_pharmacie,
      "adresse_physique": this.adresse_physique,
      "longitude": double.parse(this.longitude.toString()),
      "latitude": double.parse(this.latutude.toString()),
    };

    // Envoie les données à l'API
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
          idPhar =apiData['id'];
          // Ajout dans la base locale avec les données de l'API
           await ModelPharmacie.base.ajoutDonnees(this.nomTable, {
          "nom_pharmacie": apiData['nom_pharmacie'],
          "adresse_physique":apiData['adresse_physique'],
          "longitude": apiData['longitude'],
          "latitude": apiData['latitude'], // ID renvoyé par l'API
          });
        }
      }  else {
        print("Erreur lors de l'envoi : ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    }

    return idPhar;
  }

  static affId(int id) {
    String requette = "select * from pharmacie where id_pharmacie=$id";
    return ModelPharmacie.base.reccuperationDonnees(requette);
  }
}


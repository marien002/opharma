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
    // Ajout dans la base locale
    int id_phar = await ModelPharmacie.base.ajoutDonnees(this.nomTable, {
      "nom_pharmacie": this.nom_pharmacie,
      "adresse_physique": this.adresse_physique,
      "longitude": this.longitude,
      "latitude": this.latutude,
    });

    // Prépare les données pour l'API
    Map<String, dynamic> data = {
      "nom_pharmacie": this.nom_pharmacie,
      "adresse_physique": this.adresse_physique,
      "longitude": this.longitude,
      "latitude": this.latutude,
    };

    // Envoie les données à l'API
    Uri url = Uri.parse(Endpoint.baseUrlEnregisterpharmacie);
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print("Données envoyées avec succès : ${response.body}");
      } else {
        print("Erreur lors de l'envoi : ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    }

    return id_phar;
  }

  static affId(int id) {
    String requette = "select * from pharmacie where id_pharmacie=$id";
    return ModelPharmacie.base.reccuperationDonnees(requette);
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opharma/utils/Endpoint.dart';
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';



class ModelPharmacie  {
  late   int ? id;
  String nom_pharmacie;

 late  String adresse_pharmacie;

  String longitude;
  String latutude;
  int id_utilisateur;

  String nomTable="pharmacie";
  static BaseDeDonnee base=new  BaseDeDonnee();

  ModelPharmacie({this.id,required this.nom_pharmacie,required this.longitude, required this.latutude,required this.id_utilisateur});

  Map<String, dynamic> toMap() {
    return {
      "nom_pharmacie": nom_pharmacie,
      'longitude': longitude,
      'latitude': latutude,
      'id_utilisateur': id_utilisateur,
    };
  }



   creation()async {
    Map<String, dynamic> data = ModelPharmacie(nom_pharmacie: nom_pharmacie,
        longitude: longitude, latutude: latutude, id_utilisateur: this.id_utilisateur).toMap();
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

          // Ajout dans la base locale avec les données de l'API
          int id_utilisateur = await base.ajoutDonnees("pharmacie",data);
        }
      }  else {
        print("Erreur lors de l'envoi : ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Erreur réseau : $e");
    }

   // int id_utilisateur=await base.ajoutDonnees("pharmacie",pharmacie.toMap());
    return id_utilisateur;

  }

  affId(int id) {
    String requette="select * from pharmacie where id_pharmacie=$id";
    return ModelPharmacie.base.recuperationDonnees(requette);
  }
}




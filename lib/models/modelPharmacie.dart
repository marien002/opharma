
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';



class ModelPharmacie  {
  late   int ? id;


  String adresse_pharmacie;
  String longitude;
  String latutude;
  int id_utilisateur;

  String nomTable="pharmacie";
  static BaseDeDonnee base=new  BaseDeDonnee();

  ModelPharmacie({this.id,required this.adresse_pharmacie,required this.longitude, required this.latutude,required this.id_utilisateur});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adresse_pharmacie': adresse_pharmacie,
      'longitude': longitude,
      'latitude': latutude,
      'id_utilisateur': id_utilisateur,
    };
  }


  static creation(ModelPharmacie pharmacie)async {
    int id_utilisateur=await base.ajoutDonnees("pharmacie",pharmacie.toMap());
    return id_utilisateur;

  }


}

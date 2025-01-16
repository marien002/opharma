
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';



class ModelPharmacie  {
  late   int ? id_pharmacie;
  String nom_pharmacie;

  String adresse_physique;

  String longitude;
  String latutude;

  String nomTable="pharmacie";
  static BaseDeDonnee base=new  BaseDeDonnee();

  ModelPharmacie(this.nom_pharmacie,this.adresse_physique,this.longitude,this.latutude);

  ajouter() async{
    int id_phar=await ModelPharmacie.base.ajoutDonnees(this.nomTable,{"nom_pharmacie":this.nom_pharmacie,
      "adresse_physique":this.adresse_physique,
      "longitude":this.latutude,
      "latitude":this.longitude,

    });
    return  id_phar;

  }

  static affId(int id) {
    String requette="select * from pharmacie where id_pharmacie=$id";
    return ModelPharmacie.base.reccuperationDonnees(requette);
  }


}

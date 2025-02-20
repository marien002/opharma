
import '../elper/navigation.dart';
import '../models/modelPharmacie.dart';
import '../models/ModelUtilisateur.dart';
import '../view/auth/pageAuthentificationPharma.dart';
import '../view/pharmacie/pageEnregistrement.dart';

class Controler_pharmacie{

  var context;
  Controler_pharmacie(this.context);


  ajouter(){
    navigation(context,pageEnregistrement());
  }

  Enregistrer( {nom_pharmacie,adresse_physique,mot_de_passe,login,latitude,longitude})async{

    int id_utilisateur = await ModelUtilisateur
        .creation( ModelUtilisateur
      (nom: "omega",login: "0000",password:"0000"));
    ModelPharmacie.creation( ModelPharmacie(adresse_pharmacie:"gggg",longitude: "33",latutude: "22",id_utilisateur: id_utilisateur));
    navigation(context,pageAuthentificationPharma());

  }

  supprimer(){

  }

}
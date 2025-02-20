
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

    //String nom;
    //String login;
    //String password;

    //var pharmacie= ModelUtilisateur(nom_pharmacie,adresse_physique,latitude,longitude);
    var val = await ModelUtilisateur.creation( ModelUtilisateur(nom: "omega",login: "0000",password:"0000"));

    navigation(context,pageAuthentificationPharma());

  }

}
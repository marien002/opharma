
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

    var id_pharmacie= ModelPharmacie(nom_pharmacie,adresse_physique,latitude,longitude).ajouter();
    var val = await ModelUtilisateur.creation(await id_pharmacie,"pharmacie",login,mot_de_passe);

    navigation(context,pageAuthentificationPharma());

  }

}
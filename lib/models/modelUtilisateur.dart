
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';


class ModelUtilisateur{

  static BaseDeDonnee base=new  BaseDeDonnee();

  static creation(id_utilisateurs,type_utilisateur,login,mot_de_passe)async {
   int id_utilisateur=await base.ajoutDonnees("utilisateur",{
      "id_utilisateur":id_utilisateurs,
      "type_utilisateur":type_utilisateur,
      "login":login,
      "mot_de_passe":mot_de_passe,
    });

   return id_utilisateur;

  }




  static connecter(String login,String mot_de_passe,String type)async {

    print([ login,mot_de_passe, type]);
    var boll=false;
    var droit="";
    String requette="select id_utilisateur from utilisateur where type_utilisateur='$type' and mot_de_passe='$mot_de_passe' and login='$login'";
    var val=await ModelUtilisateur.base.reccuperationDonnees(requette);
    print(val[0]["id_utilisateur"]);

    if(val.length!=0){
      Session.id_connect=val[0]["id_utilisateur"];
      boll=true;
    }
    return [boll,droit];
  }

  static deconnection(){
    Session.id_connect=0;
  }


}

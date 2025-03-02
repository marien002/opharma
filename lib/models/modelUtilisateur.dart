
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';


class ModelUtilisateur{

  static BaseDeDonnee base=new  BaseDeDonnee();

  int? id;
  String nom;
  String login;
  String password;

  ModelUtilisateur({this.id, required this.nom, required this.login, required this.password});

  // Convertir en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom_utilisateur': nom,
      'login': login,
      'password': password,
    };
  }

  // Convertir depuis Map (depuis SQLite)
  factory ModelUtilisateur.fromMap(Map<String, dynamic> map) {
    return ModelUtilisateur(
      id: map['id'],
      nom: map['nom_utilisateur'],
      login: map['login'],
      password: map['password'],
    );
  }


  static creation(ModelUtilisateur utilisateur)async {

     int id_utilisateur=await base.ajoutDonnees("utilisateur",utilisateur.toMap());
     return id_utilisateur;

  }

  static connecter(String login,String mot_de_passe,String type)async {

  }



  static deconnection(){
    Session.id_connect=0;
  }


}

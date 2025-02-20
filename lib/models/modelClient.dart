
import '../session/Session.dart';
import 'baseDeDonnee/BaseDeDonnee.dart';


class ModelClient  {

  String  nom;
  String  prenom;
  String  adresse;

  String nomTable="client";
  static BaseDeDonnee base=new  BaseDeDonnee();

ModelClient(this.nom,this.prenom,this.adresse);



}
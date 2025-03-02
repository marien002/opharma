
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

    int id_utilisateur = await ModelUtilisateur(nom: nom_pharmacie,login :login, password: mot_de_passe).creation();


   ModelPharmacie(nom_pharmacie:"gggg",longitude: "33",latutude: "22",id_utilisateur: id_utilisateur).creation();

    print(id_utilisateur );
    if(id_utilisateur is int){Fluttertoast.showToast(
      msg: "Compte créé avec succès !",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    navigation(context,pageAuthentificationPharma());}
    else{
      Fluttertoast.showToast(
        msg: "une erreur ce produit lors d'envoi !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    navigation(context,pageAuthentificationPharma());

  }

  supprimer(){

  }

}
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:opharma/models/modelUtilisateur.dart';
import 'package:opharma/elper/navigation.dart';
import '../models/modelClient.dart';
import '../models/modelPharmacie.dart';
import '../view/auth/pageAuthentificationClient.dart';
import '../view/auth/pageAuthentificationPharma.dart';
import '../view/espaceClient/accueilClient.dart';
import '../view/gestionPharmacie/adminPharmacie/AcceuilAdmin.dart';

class controllerAuth{
  var context;
  controllerAuth(this.context);
  authPhar(){
    navigation(context,pageAuthentificationPharma());
  }

  connecter(String login,String mot_de_passe,{type="pharmacie"})async{
    var val =await ModelUtilisateur.connecter(login, mot_de_passe,type);
    print(val);
    if(val[0]==true){
      Fluttertoast.showToast(
        msg: "Compte créé avec succès !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      navigation(context,pageAccueille());
    }else{
      Fluttertoast.showToast(
        msg: "une erreur ce produit lors d'envoi !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 26.0,
      );

      navigation(context,pageAuthentificationPharma());
    }

    }

  deconnecter(){
    ModelUtilisateur.deconnection();
    navigation(context,pageAuthentificationPharma());
  }
  }



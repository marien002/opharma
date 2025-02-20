import 'package:flutter/material.dart';
import '../../controlers/controler_pharmacie.dart';
import '../../controlers/controllerAuth.dart';
import 'package:opharma/elper/navigation.dart';
import '../componentGenerale/ButtonCostom.dart';
import '../componentGenerale/Combobox.dart';
import '../componentGenerale/InputCostom.dart';
import '../componentGenerale/entete.dart';
import '../leyouts/base.dart';


class pageEnregistrement extends StatefulWidget {
  static String nom_pharmacie="";
  static String adresse_physique="";
  static String mot_de_passe="";
  static String login="";

  static String longitude="";
  static String latitude="";

  @override
  State<pageEnregistrement> createState() => pageEnregistrementState();
}
class pageEnregistrementState extends State<pageEnregistrement> {
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size;
    double largInp=h.width-18;
    var longInp=50;
    var colorButton= Color.fromRGBO(50, 190, 166, 1);
    var colorInput=Color.fromRGBO(230, 230, 230,1);

    ButtonCostom localisation= ButtonCostom("Localisation via la map",colorButton,(){

    },rad: 9);

    InputCostom nomPharma=InputCostom(Name:"nomPharma",lar:longInp,long:largInp,
        value: "Nom du pharmacie",
        couleur:colorInput
    );
    InputCostom adresse=InputCostom(Name:"Adresse_physique",lar:longInp,long:largInp,
        value: "Adresse physique",
        couleur:colorInput
    );


    InputCostom login=InputCostom(Name:"login",lar:longInp,long:largInp,
        value: "login",
        couleur:colorInput
    );
    InputCostom motDePasse=InputCostom(Name:"motDePasse",lar:longInp,long:largInp,
        value: "mot de passe",
        couleur:colorInput
    );
    InputCostom motDePasseConfirmation=InputCostom(Name:"motDePasseConfirmation",lar:longInp,long:largInp,
        value: "confirmer votre mot de passe",
        couleur:colorInput
    );

    return  Scaffold(
        appBar:Entete(
            flecheR: false,
            context: context,
            title: "",
            pageCible: null,
            text: "",
            logo: null
        ).Demarrer(),

        body:Base(
          content: Column(
            children: [
              blockEnregistrement(
                "Créer un compte pharmacie ",
                [
                  nomPharma.lancer(),
                  adresse.lancer(),
                 login.lancer(),
                 motDePasse.lancer(),
                  localisation.lancer(),

                  ButtonCostom("Créer le compte",colorButton,(){
                    Controler_pharmacie(context).Enregistrer(
                       nom_pharmacie:  nomPharma.ValueAf(),
                        adresse_physique: adresse.ValueAf(),
                        login: login.ValueAf(),
                       mot_de_passe: motDePasse.ValueAf(),
                        latitude: "22",
                        longitude: "22",
                );
                  },rad: 9).lancer()



                ],
                tailleT: 45
              )
            ],
          ) ,
          child: []
        ).lancer(h.height-270,h.width-25),
    );

  }

}




Widget  blockEnregistrement(String title,List<Widget> element,{tailleT=60}){
  Widget titre=Container(
    height: tailleT.toDouble(),
    child: Center(child:Text(
        title,
      style: TextStyle(
        color:  Color.fromRGBO(50, 190, 166, 1),
        fontSize: 22
      ),
    )
    ),
  );
  element.insert(0,titre);

  return Expanded(child:
  Container(

    child:Padding(
      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: element,
      ),
    ) ,
  )
  )  ;




}

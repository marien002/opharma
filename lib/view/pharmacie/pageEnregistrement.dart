import 'package:flutter/material.dart';
import '../../controlers/controler_pharmacie.dart';
import '../../controlers/controllerAuth.dart';
import 'package:opharma/elper/navigation.dart';
import '../componentGenerale/ButtonCostom.dart';
import '../componentGenerale/Combobox.dart';
import '../componentGenerale/InputCostom.dart';
import '../componentGenerale/entete.dart';
import '../leyouts/base.dart';
import 'package:geolocator/geolocator.dart';

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
  Position? _currentPosition;
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size;
    double largInp=h.width-18;
    var longInp=50;
    var colorButton= Color.fromRGBO(50, 190, 166, 1);
    var colorInput=Color.fromRGBO(230, 230, 230,1);

    ButtonCostom localisation= ButtonCostom("Localisation via la map",colorButton,(){
    _getCurrentPosition();
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
        value: "Téléphone ou Email",
        couleur:colorInput
    );
    InputCostom motDePasse=InputCostom(Name:"motDePasse",lar:longInp,long:largInp,
        value: "Mot de passe",
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
                 login.lancer(),
                  adresse.lancer(),
                 motDePasse.lancer(),


                  ButtonCostom("Créer le compte",colorButton,(){
                    _getCurrentPosition();
                    Controler_pharmacie(context).Enregistrer(
                       nom_pharmacie:  nomPharma.ValueAf(),
                        adresse_physique: adresse.ValueAf(),
                        login: login.ValueAf(),
                       mot_de_passe: motDePasse.ValueAf(),
                        latitude: "${_currentPosition?.latitude}",
                        longitude: "${_currentPosition?.longitude}",
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
  // Méthode pour obtenir la position de l'utilisateur
  Future<void> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Le service de localisation est désactivé.');
    }

    // Vérifie et demande les permissions de localisation
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('La permission de localisation est refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'La permission de localisation est refusée en permanence.');
    }

    // Obtient la position actuelle
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
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

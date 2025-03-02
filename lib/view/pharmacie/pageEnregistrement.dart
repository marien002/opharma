import 'package:flutter/material.dart';
import '../../controlers/controler_pharmacie.dart';
import '../../controlers/controllerAuth.dart';
import 'package:opharma/elper/navigation.dart';
import '../auth/pageAuthentificationPharma.dart';
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
  bool etat = false;
  bool pswdVisible = false;
  bool isLoading = false;
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
        couleur:colorInput,
        icon: Icon(Icons.local_pharmacy_outlined)
    );
    InputCostom adresse=InputCostom(Name:"Adresse_physique",lar:longInp,long:largInp,
        value: "Adresse physique",
        couleur:colorInput,
      icon: Icon(Icons.home_filled)

    );


    InputCostom login=InputCostom(Name:"login",lar:longInp,long:largInp,
        value: "Téléphone ou Email",
        couleur:colorInput,
        icon: Icon(Icons.login)
    );
    InputCostom motDePasse=InputCostom(Name:"motDePasse",lar:longInp,long:largInp,
        value: "motDepasse",
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

          bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: isLoading ?SizedBox.square(): _authentification(),
      ),

       body: Stack( children: [

         Base(
          content: Column(
            children: [
              blockEnregistrement(
                "Créer un compte pharmacie ",
                [
                  SizedBox(height: 20,),
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
    if (isLoading)
    Container(
    color: Colors.black.withOpacity(0.32), // Fond noir semi-transparent
    child: Center(
    child: CircularProgressIndicator(color:Color.fromRGBO(50, 190, 166, 1) ,strokeWidth: 4,),
    ),)],)
    );

  }
  _authentification() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(" Vous avez deja un "),
          TextButton(onPressed: () {

            navigation(context,pageAuthentificationPharma());
          },
              child: Text("Compte",
               // style: GoogleFonts.montserrat(color: MyColor.c1),
              ))
        ]);
  }
  Widget _checkBox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: etat,
          onChanged: (value) {
            setState(() {
              etat = value ?? false;
              if (etat) {
                _getCurrentPosition();
              }
            });



          },
          activeColor: const Color.fromRGBO(50, 190, 166, 1),
        ),
        Expanded(
          child: Text(
            "J’ai lu et j’accepte les Termes et Conditions dont "
                "les conditions générales d’utilisation et la Politique de Confidentialité",
            maxLines: 3,
          ),
        )
      ],
    );
  }

  // Méthode pour obtenir la position actuelle
  Future<void> _getCurrentPosition() async {
    try {
      // Vérifie si le service de localisation est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Le service de localisation est désactivé.');
      }

      // Vérifie et demande les permissions de localisation
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('La permission de localisation est refusée.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'La permission de localisation est refusée en permanence.');
      }

      // Obtient la position actuelle
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      // Affiche une erreur si quelque chose échoue
      print('Erreur: $e');
    }
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: element,
      ),
    ) ,
  )
  )  ;




}

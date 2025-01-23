import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        value: "Mot de passe",
        couleur:colorInput,
        icon: IconButton(onPressed: (){
        setState(() {
          pswdVisible = !pswdVisible;
        });
      }, icon: pswdVisible ?Icon( Icons.visibility ,color: Color.fromRGBO(50, 190, 166, 1)) :Icon( Icons.visibility_off,color: Color.fromRGBO(50, 190, 166, 1))),

      estcache: pswdVisible,

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
        child: _authentification(),
      ),

       body:Base(
          content: Column(
            children: [
              blockEnregistrement(
                "Créer un compte pharmacie ",
                [
                  SizedBox(height: 20,),
                  nomPharma.lancer(),
                  SizedBox(height: 20,),
                 login.lancer(),
                  SizedBox(height: 20,),
                  adresse.lancer(),
                  SizedBox(height: 20,),
                 motDePasse.lancer(),
                  SizedBox(height: 20,),
                  _checkBox(),
                  SizedBox(height: 20,),

                  ButtonCostom("Créer le compte",colorButton,(){
                    if(nomPharma.ValueAf() == null || nomPharma.ValueAf().isEmpty ||
                        adresse.ValueAf() == null || adresse.ValueAf().isEmpty ||
                        login.ValueAf() == null || login.ValueAf().isEmpty ||
                        motDePasse.ValueAf() == null || motDePasse.ValueAf().isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Veuillez remplir tous les champs obligatoires.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }
                    // Validation du login (email ou numéro de téléphone)
                    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                    final phoneRegex = RegExp(r"^\+?[0-9]{10,15}$"); // Accepte un numéro international ou national

                    if (!emailRegex.hasMatch(login.ValueAf()) && !phoneRegex.hasMatch(login.ValueAf())) {
                      Fluttertoast.showToast(
                        msg: "Veuillez entrer un email ou un numéro de téléphone valide.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.orangeAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }
                    // Validation du mot de passe
                    final passwordRegex = RegExp(r'^(?=.*?[!@#\$&*~]).{8,}$'); // Au moins 8 caractères et un caractère spécial
                    if (!passwordRegex.hasMatch(motDePasse.ValueAf())) {
                      Fluttertoast.showToast(
                        msg: "Le mot de passe doit contenir au moins 8 caractères et un caractère spécial.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.orangeAccent,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    else{
                      Fluttertoast.showToast(
                        msg: "Compte créé avec succès !",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      print("${_currentPosition?.latitude}   ${_currentPosition?.longitude}");

                    Controler_pharmacie(context).Enregistrer(
                       nom_pharmacie:  nomPharma.ValueAf(),
                        adresse_physique: adresse.ValueAf(),
                        login: login.ValueAf(),
                       mot_de_passe: motDePasse.ValueAf(),
                        latitude: "${_currentPosition?.latitude}",
                        longitude: "${_currentPosition?.longitude}",
                );
                      };
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
        Checkbox(value: etat, onChanged: (value) {
          setState(() {

          });
          etat = !etat;
          _getCurrentPosition();
        }, activeColor: Color.fromRGBO(50, 190, 166, 1),),
        Expanded(
          child: Text("J’ai lu et j’accepte les Termes et Conditions dont "
              "les  conditions générales d’utilisation et la Politique de Confidentialité",
            maxLines: 3, ),
        )
      ],);
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: element,
      ),
    ) ,
  )
  )  ;




}

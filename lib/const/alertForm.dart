import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:opharma/const/widgets.dart';

//import 'package:soos_alerts/const/widgets.dart';

void showAlertForm(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String alertType = 'Urgence';
  String link = '';
  String description = '';
  List<XFile> selectedImages = [];

  final ImagePicker picker = ImagePicker();

  Future<void> pickImages() async {
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      selectedImages.addAll(pickedFiles);
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header avec titre et sous-titre
                  Text(
                    "Reserveation ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Remplissez les champs ci-dessous pour soumettre une ordonance.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Formulaire
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Type d'alerte



                        // Lieu

                        SizedBox(height: 15),

                        // Bouton de sélection d'images
                        CustomButton(
                          text: "Sélectionner des images",
                          onPressed: () async {
                            await pickImages();
                            setState(
                                () {}); // Mettre à jour l'UI après la sélection
                          },
                          icon: Icons.image,
                          backgroundColor: Colors.grey,
                        ), 
                        SizedBox(height: 15),

                        // Aperçu des images sélectionnées
                        selectedImages.isNotEmpty
                            ? Wrap(
                                spacing: 8,
                                children: selectedImages.map((image) {
                                  return Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: FileImage(File(image.path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedImages.remove(image);
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close,
                                              size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              )
                            : Text(
                                "Aucune image sélectionnée. Appuyez sur le bouton pour en ajouter.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                        SizedBox(height: 20),

                        // Bouton de soumission
                        CustomButton(
                          text: "Envoyer",
                          onPressed: () {
                            // Action du bouton
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Footer
                  Text(
                    "Merci de contribuer à la sécurité et à l'information de la communauté.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

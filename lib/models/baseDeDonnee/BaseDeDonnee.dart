
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BaseDeDonnee {

  Database ? _database;

  Future<Database> get database async{
    if(_database!=null)return _database!;
    return await createDatabase();
  }

  Future<Database> createDatabase () async {
    Directory directory=await getApplicationDocumentsDirectory();
    final path=join(directory.path,"omegapharma31.db");
    return await openDatabase(
      path,
      version:1,
        onCreate: onCreate
    );

  }
  onCreate(Database database, int version) async {
    // Création des tables

    await database.execute('''
      CREATE TABLE utilisateur (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type_utilisateur TEXT NOT NULL,
          id_utilisateur INTEGER NOT NULL,
          login TEXT NOT NULL,
          mot_de_passe TEXT NOT NULL
      );
    ''');

    await database.execute('''
      CREATE TABLE forme (
          id_forme INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_forme TEXT NOT NULL
      );
    ''');

    await database.execute('''
      CREATE TABLE dose (
          id_dose INTEGER PRIMARY KEY AUTOINCREMENT,
          quantite_dose TEXT NOT NULL,
          unite_dose TEXT
      );
    ''');

    await database.execute('''
      CREATE TABLE medicament (
          id_medicament INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_medicament TEXT NOT NULL,
          id_dose INTEGER,
          id_forme INTEGER,
          FOREIGN KEY (id_dose) REFERENCES dose (id_dose),
          FOREIGN KEY (id_forme) REFERENCES forme (id_forme)
      );
    ''');

    await database.execute('''
      CREATE TABLE pharmacie (
          id_pharmacie INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_pharmacie TEXT NOT NULL,
          adresse_physique TEXT NOT NULL,
          latitude TEXT,
          longitude TEXT
      );
    ''');

    await database.execute('''
      CREATE TABLE medicament_pharmacie (
          id_medicament INTEGER,
          id_pharmacie INTEGER,
          prix_medicament TEXT,
          quantite INTEGER,
          date_expi_medicament TEXT,
          PRIMARY KEY (id_medicament, id_pharmacie),
          FOREIGN KEY (id_medicament) REFERENCES medicament (id_medicament),
          FOREIGN KEY (id_pharmacie) REFERENCES pharmacie (id_pharmacie)
      );
    ''');

    await database.execute('''
      CREATE TABLE vente (
          id_vente INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          heure TEXT NOT NULL,
          qte_totale INTEGER,
          montant_total INTEGER,
          nom_client TEXT
      );
    ''');

    await database.execute('''
      CREATE TABLE medicament_vente (
          id_vente INTEGER,
          id_pharmacie INTEGER,
          id_medicament INTEGER,
          quantite INTEGER,
          FOREIGN KEY (id_vente) REFERENCES vente (id_vente),
          FOREIGN KEY (id_pharmacie) REFERENCES pharmacie (id_pharmacie),
          FOREIGN KEY (id_medicament) REFERENCES medicament (id_medicament)
      );
    ''');

    await database.execute('''
      CREATE TABLE client (
          id_client INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_client TEXT,
          prenom_client TEXT,
          adresse_client TEXT,
          numero_client TEXT
      );
    ''');

    await database.execute('''
      CREATE TABLE reservation (
          id_reservation INTEGER PRIMARY KEY AUTOINCREMENT,
          id_client INTEGER,
          id_pharmacie INTEGER,
          quantite INTEGER,
          montant_total INTEGER,
          date TEXT,
          heure TEXT,
          status TEXT,
          FOREIGN KEY (id_client) REFERENCES client (id_client),
          FOREIGN KEY (id_pharmacie) REFERENCES pharmacie (id_pharmacie)
      );
    ''');

    await database.execute('''
      CREATE TABLE reservation_medicament (
          id_reservation INTEGER,
          id_medicament INTEGER,
          id_pharmacie INTEGER,
          id_client INTEGER,
          quantite INTEGER,
          FOREIGN KEY (id_reservation) REFERENCES reservation (id_reservation),
          FOREIGN KEY (id_medicament) REFERENCES medicament (id_medicament),
          FOREIGN KEY (id_pharmacie) REFERENCES pharmacie (id_pharmacie)
      );
    ''');

    await database.execute('''
      CREATE TABLE abonnement (
          id_abonnement INTEGER PRIMARY KEY AUTOINCREMENT,
          date_debut TEXT,
          date_fin TEXT,
          id_type_abonnement INTEGER,
          FOREIGN KEY (id_type_abonnement) REFERENCES type_abonnement (id_type_abonnement)
      );
    ''');

    await database.execute('''
      CREATE TABLE type_abonnement (
          id_type_abonnement INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_type_abonnement TEXT
      );
    ''');
  }



  Future<List<Map<dynamic,dynamic>>> reccuperationDonnees (String requette) async{
    Database db=await database;
    List<Map<dynamic,dynamic>> mapliste=await db.rawQuery(requette);
    return mapliste.toList();
  }

  Future<int>ajoutDonnees(String table,Map<String,dynamic> value) async{
    Database db=await database;
   var f= await db.insert(table,value);
    return f;
  }
  Future<void>modifier(String sql) async{
    Database db=await database;
    var f= await db.execute(sql);
  }








}
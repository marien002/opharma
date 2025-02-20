import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BaseDeDonnee {
  Database ? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await createDatabase();
  }

  Future<Database> createDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "omegaBase.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: onCreate,
    );
  }

  onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE Utilisateur (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_utilisateur TEXT NOT NULL,
          login TEXT NOT NULL,
          password TEXT NOT NULL
      );
    ''');

    await database.execute('''
      CREATE TABLE Pharmacie (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          adresse_pharmacie TEXT NOT NULL,
          latitude TEXT,
          longitude TEXT,
          id_utilisateur INTEGER,
          FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
      );
    ''');

    await database.execute('''
      CREATE TABLE Client (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          adresse_client TEXT,
          prenom_utilisateur TEXT,
          id_utilisateur INTEGER,
          FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
      );
    ''');

    await database.execute('''
      CREATE TABLE Type_abonnement (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_type_abonnement TEXT,
          montant INTEGER
      );
    ''');

    await database.execute('''
      CREATE TABLE Abonnement (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date_debut TEXT,
          date_fin TEXT,
          id_type_abonnement INTEGER,
          id_pharmacie INTEGER,
          FOREIGN KEY (id_type_abonnement) REFERENCES Type_abonnement(id_type_abonnement),
          FOREIGN KEY (id_pharmacie) REFERENCES Pharmacie(id_pharmacie)
      );
    ''');

    await database.execute('''
      CREATE TABLE Forme (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_forme TEXT NOT NULL
      );
    ''');

    await database.execute('''
      CREATE TABLE Dose (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          quantite_dose TEXT NOT NULL,
          unite_dose TEXT
      );
    ''');

    await database.execute('''
      CREATE TABLE Medicament (
          id_medicament INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_medicament TEXT NOT NULL
      );
    ''');

    await database.execute('''
      CREATE TABLE Vente (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date_vente TEXT NOT NULL,
          prix_totale INTEGER,
          quantite_totale INTEGER
      );
    ''');

    await database.execute('''
      CREATE TABLE Vente_normal (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom_client TEXT,
          id_vente INTEGER,
          FOREIGN KEY (id_vente) REFERENCES Vente(id_vente)
      );
    ''');

    await database.execute('''
      CREATE TABLE Reservation (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          status TEXT,
          id_client INTEGER,
          id_vente INTEGER,
          FOREIGN KEY (id_client) REFERENCES Client(id_client),
          FOREIGN KEY (id_vente) REFERENCES Vente(id_vente)
      );
    ''');

    await database.execute('''
      CREATE TABLE Pharmacie_medicament (
          id_pharmacie INTEGER,
          id_medicament INTEGER,
          id_dose INTEGER,
          id_forme INTEGER,
          prix_unitaire TEXT,
          quantite INTEGER,
          date_expiration TEXT,
          PRIMARY KEY (id_pharmacie, id_medicament, id_dose, id_forme),
          FOREIGN KEY (id_pharmacie) REFERENCES Pharmacie(id_pharmacie),
          FOREIGN KEY (id_medicament) REFERENCES Medicament(id_medicament),
          FOREIGN KEY (id_dose) REFERENCES Dose(id_dose),
          FOREIGN KEY (id_forme) REFERENCES Forme(id_forme)
      );
    ''');
  }


  Future<List<Map<dynamic, dynamic>>> recuperationDonnees(String requete) async {
    Database db = await database;
    List<Map<dynamic, dynamic>> mapListe = await db.rawQuery(requete);
    return mapListe.toList();
  }


  Future<int> ajoutDonnees(String table, Map<String, dynamic> value) async {
    Database db = await database;
    return await db.insert(table, value);
  }


  Future<void> modifier(String sql) async {
    Database db = await database;
    await db.execute(sql);
  }

}

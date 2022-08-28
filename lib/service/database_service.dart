import 'package:gen_invo/Models/item_model.dart';
import 'package:gen_invo/Models/party_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/company_model.dart';
import '../Models/invoice_model.dart';
import '../Models/invoice_result_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('GenInvo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute('ALTER TABLE Invoice ADD COLUMN eta TEXT');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE party ( 
  partyId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
  name TEXT NOT NULL,
  mobile TEXT,
  email TEXT,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  address TEXT,
  gst TEXT
  )
''');

    await db.execute('''
CREATE TABLE item (
  itemId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  hsn INTEGER NOT NULL,
  isDefault INTEGER NOT NULL
  )
''');

    await db.execute('''
CREATE TABLE invoice (
  id INTEGER NOT NULL PRIMARY KEY,
  pId INTEGER NOT NULL,
  iId INTEGER NOT NULL,
  date TEXT NOT NULL,
  weightInGrams REAL NOT NULL,
  ratePerGram REAL NOT NULL,
  totalCost REAL NOT NULL, 
  cgst REAL NOT NULL,
  sgst REAL NOT NULL,
  igst REAL NOT NULL,
  totalAmountWithoutRounding REAL NOT NULL,
  totalAmountWithRounding INTEGER NOT NULL,
  discount INTEGER,
  isCash INTEGER NOT NULL,
  receivedInCash INTEGER,
  isUPI INTEGER NOT NULL,
  receivedInUPI INTEGER NOT NULL,
  isCheque INTEGER NOT NULL,
  bankName TEXT NOT NULL,
  chequeNumber TEXT NOT NULL,
  receivedInCheque INTEGER NOT NULL,
  isRTGS INTEGER NOT NULL,
  rtgsState TEXT NOT NULL,
  netAmount INTEGER NOT NULL,
  netBalance INTEGER NOT NULL,
  isAdjusted INTEGER NOT NULL,
  eta TEXT
  )
''');

    await db.execute('''
CREATE TABLE company (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  gstNumber TEXT NOT NULL,
  phoneNumber INTEGER NOT NULL,
  address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  stateCode INTEGER NOT NULL,
  bankName TEXT NOT NULL,
  accountNumber INTEGER NOT NULL,
  ifscCode TEXT NOT NULL,
  bankAddress TEXT NOT NULL
  )
''');
  }

  // ------------------------------------------------- Party CRUD -------------------------------

  Future<PartyModel> insertPartyData(PartyModel item) async {
    final db = await instance.database;
    final id = await db.insert("party", item.toJson());
    return item.copyWith(partyId: id);
  }

  Future<List<PartyModel>> getPartyList() async {
    final db = await instance.database;
    final res = await db.query("party");
    return res.map((e) => PartyModel.fromJson(e)).toList();
  }

  Future<void> deleteParty(PartyModel party) async {
    final db = await instance.database;
    await db.delete("party", where: "partyId = ?", whereArgs: [party.partyId]);
  }

  Future<void> updateParty(PartyModel party) async {
    final db = await instance.database;
    await db.update("party", party.toJson(),
        where: "partyId = ?", whereArgs: [party.partyId]);
  }

  // ------------------------------------------- Item CRUD ------------------------------

  Future<ItemModel> insertItemData(ItemModel item) async {
    final db = await instance.database;
    final id = await db.insert("item", item.toJson());
    return item.copyWith(itemId: id);
  }

  Future<List<ItemModel>> getItemList() async {
    final db = await instance.database;
    final res = await db.query("item");
    return res.map((e) => ItemModel.fromJson(e)).toList();
  }

  Future<void> deleteItem(ItemModel item) async {
    final db = await instance.database;
    await db.delete("item", where: "itemId = ?", whereArgs: [item.itemId]);
  }

  Future<void> updateItem(ItemModel item) async {
    final db = await instance.database;
    await db.update("item", item.toJson(),
        where: "itemId = ?", whereArgs: [item.itemId]);
  }

  Future<void> setDefaultItem(ItemModel item) async {
    final db = await instance.database;
    await db.rawQuery("UPDATE item SET isDefault = 0");
    ItemModel temp = item.copyWith(isDefault: 1);
    await db.update("item", temp.toJson(),
        where: "itemId = ?", whereArgs: [item.itemId]);
  }

  // ------------------------------------------- Invoice CRUD --------------------------------

  Future<List<InvoiceResultModel>> getInvoiceList() async {
    final db = await instance.database;
    final res = await db.rawQuery("""
SELECT * FROM invoice
LEFT JOIN party ON invoice.pId = party.partyId
LEFT JOIN item ON invoice.iId = item.itemId
ORDER BY invoice.id DESC
""");
    return res.map((e) => InvoiceResultModel.fromJson(e)).toList();
  }

  Future<InvoiceModel> insertInvoiceData(InvoiceModel item) async {
    final db = await instance.database;
    final id = await db.insert("invoice", item.toJson());
    return item.copyWith(id: id);
  }

  updateInvoice(InvoiceModel invoice) async {
    final db = await instance.database;
    await db.update("invoice", invoice.toJson(),
        where: "id = ?", whereArgs: [invoice.id]);
  }

  Future<void> deleteInvoice(InvoiceResultModel invoice) async {
    final db = await instance.database;
    await db.delete("invoice", where: "id = ?", whereArgs: [invoice.id]);
  }

  Future<void> updateAdjusted(InvoiceResultModel invoice) async {
    final db = await instance.database;
    await db.update("invoice", {"isAdjusted": invoice.isAdjusted},
        where: "id = ?", whereArgs: [invoice.id]);
  }

  Future<InvoiceResultModel> getInvoiceById(int id) async {
    final db = await instance.database;
    final res = await db.rawQuery("""
SELECT * FROM invoice
LEFT JOIN party ON invoice.pId = party.partyId
LEFT JOIN item ON invoice.iId = item.itemId
WHERE id = $id
""");
    return res.map((e) => InvoiceResultModel.fromJson(e)).toList().first;
  }

  Future<List<InvoiceResultModel>> getInvoiceListByPartyId(int partyId) async {
    final db = await instance.database;
    final res = await db.rawQuery("""
SELECT * FROM invoice
LEFT JOIN party ON invoice.pId = party.partyId
LEFT JOIN item ON invoice.iId = item.itemId
WHERE pId = $partyId
""");
    return res.map((e) => InvoiceResultModel.fromJson(e)).toList();
  }

  Future<List<InvoiceResultModel>> getInvoiceListOfMonth(int month) async {
    final db = await instance.database;
    final res = await db.rawQuery("""
SELECT * FROM invoice
LEFT JOIN party ON invoice.pId = party.partyId
LEFT JOIN item ON invoice.iId = item.itemId
ORDER BY invoice.id DESC
""");

    List<Map<String, dynamic>> lst = [];
    for (var element in res) {
      final date = DateTime.parse(
          "${element['date'].toString().split("-")[2]}-${element['date'].toString().split("-")[1]}-${element['date'].toString().split("-")[0]}");
      if (date.isAfter(DateTime(DateTime.now().year, month - 1, 31)) &&
          date.isBefore(DateTime(DateTime.now().year, month + 1, 1))) {
        lst.add(element);
      }
    }
    return lst.map((e) => InvoiceResultModel.fromJson(e)).toList();
  }

  Future<List<InvoiceResultModel>> getTodayOutstandingInvoices() async {
    final db = await instance.database;
    final res = await db.rawQuery("""
SELECT * FROM invoice
LEFT JOIN party ON invoice.pId = party.partyId
LEFT JOIN item ON invoice.iId = item.itemId
WHERE eta <= '${DateTime.now().toString().split(" ")[0]}'
""");
    return res.map((e) => InvoiceResultModel.fromJson(e)).toList();
  }

  Future<void> updateETA(InvoiceResultModel invoice) async {
    final db = await instance.database;
    await db.update("invoice", {"eta": invoice.eta},
        where: "id = ?", whereArgs: [invoice.id]);
  }

  // ------------------------------------------- Company CRUD --------------------------------

  getCompanyDetails() async {
    final db = await instance.database;
    final res = await db.query("company");
    return res.map((e) => CompanyModel.fromJson(e)).toList();
  }

  Future<CompanyModel> insertCompanyData(CompanyModel company) async {
    final db = await instance.database;
    final id = await db.insert("company", company.toJson());
    return company.copyWith(id: id);
  }
}

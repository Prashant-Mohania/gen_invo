import 'package:flutter/cupertino.dart';
import '../Models/item_model.dart';
import '../service/database_service.dart';

class ItemChangeNotifier extends ChangeNotifier {
  List<ItemModel> lst = <ItemModel>[];
  final DatabaseService dbClient = DatabaseService.instance;
  double tax = .015,
      igst = .03,
      subTotal = 0,
      totalAmnt = 0,
      finalAmnt = 0,
      taxAmnt = 0,
      igstAmnt = 0,
      roundOffAmnt = 0,
      discountAmnt = 0;

  // CRUD operations
  Future fetchItemList() async {
    await dbClient.getItemList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  Future add(ItemModel item) async {
    await dbClient.insertItemData(item);
    lst.add(item);
    notifyListeners();
  }

  remove(ItemModel item) async {
    await dbClient.deleteItem(item).then((value) {
      lst.remove(item);
      notifyListeners();
    });
  }

  update(ItemModel item) async {
    await dbClient.updateItem(item);
    dbClient.getItemList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  Future setDefaultItem(ItemModel item) async {
    await dbClient.setDefaultItem(item);
    dbClient.getItemList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  // invoice Calculations
  double subTotalAmount(double total) {
    subTotal = total;
    return total;
  }

  double taxCalculation() {
    taxAmnt = subTotal * tax;
    return taxAmnt;
  }

  double igstCalculation() {
    igstAmnt = subTotal * igst;
    return igstAmnt;
  }

  double totalAmount() {
    totalAmnt = subTotal + taxAmnt + taxAmnt + igstAmnt;
    return totalAmnt;
  }

  double roundOff() {
    roundOffAmnt = totalAmnt.round() - totalAmnt;
    return roundOffAmnt;
  }

  double discountAmount(double amnt) {
    discountAmnt = amnt;
    return discountAmnt;
    // return subTotalAmount() * discount;
  }

  double finalAmount() {
    finalAmnt = totalAmnt + roundOffAmnt - discountAmnt;
    return finalAmnt;
  }

  void close() {
    totalAmnt = 0;
    subTotal = 0;
    taxAmnt = 0;
    igstAmnt = 0;
    roundOffAmnt = 0;
    discountAmnt = 0;
    finalAmnt = 0;
  }
}

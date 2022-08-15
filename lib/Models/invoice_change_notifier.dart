import 'package:flutter/cupertino.dart';
import 'package:gen_invo/Models/invoice_model.dart';

import '../service/database_service.dart';
import 'invoice_result_model.dart';

class InvoiceChangeNotifier extends ChangeNotifier {
  List<InvoiceResultModel> lst = <InvoiceResultModel>[];
  final DatabaseService dbClient = DatabaseService.instance;
  String amtBank = "0";
  String amtCash = "0";
  String amt = "0";

  Future fetchInvoiceList() async {
    await dbClient.getInvoiceList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  Future add(InvoiceModel invoice) async {
    await dbClient.insertInvoiceData(invoice).then((value) {
      fetchInvoiceList();
      // lst.add(invoice);
      // notifyListeners();
    });
  }

  Future update(InvoiceModel invoice) async {
    await dbClient.updateInvoice(invoice).then((value) {
      fetchInvoiceList();
      // lst.add(invoice);
      // notifyListeners();
    });
  }

  remove(InvoiceResultModel invoice) async {
    await dbClient.deleteInvoice(invoice).then((value) {
      fetchInvoiceList();
      // lst.remove(invoice);
      // notifyListeners();
    });
  }

  updateAdjusted(InvoiceResultModel invoice) async {
    await dbClient.updateAdjusted(invoice).then((value) {
      fetchInvoiceList();
    });
  }

  getInvoiceById(int id) async {
    final res = await dbClient.getInvoiceById(id);
    return res;
  }

  Future<List<InvoiceResultModel>> getInvoiceListBypartyId(int id) async {
    final res = await dbClient.getInvoiceListByPartyId(id);
    return res;
  }

  getInvoiceListOfMonth(int month) async {
    int bank = 0, cash = 0;
    final res = await dbClient.getInvoiceListOfMonth(month);
    for (var ele in res) {
      if (ele.isCash != 1) {
        // amtBank = (bank + ele.netAmount!).toString();
        bank += ele.netAmount!;
      } else {
        // amtCash = (cash + ele.netAmount!).toString();
        cash += ele.netAmount!;
      }
    }
    amtBank = bank.toString();
    amtCash = cash.toString();
    amt = (bank + cash).toString();
    // return res;
  }
}

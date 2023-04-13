import 'package:flutter/cupertino.dart';
import 'package:gen_invo/Models/invoice_model.dart';

import '../service/database_service.dart';
import 'invoice_result_model.dart';

class InvoiceChangeNotifier extends ChangeNotifier {
  List<InvoiceResultModel> lst = <InvoiceResultModel>[];
  List<InvoiceResultModel> lastYearLst = <InvoiceResultModel>[];
  final DatabaseService dbClient = DatabaseService.instance;

  // month invoices data
  String amtBank = "0";
  String amtCash = "0";
  String amt = "0";

  List<InvoiceResultModel> bankInvoices = <InvoiceResultModel>[];
  List<InvoiceResultModel> cashInvoices = <InvoiceResultModel>[];
  List<InvoiceResultModel> invoices = <InvoiceResultModel>[];

  List<InvoiceResultModel> outstandingInvoices = <InvoiceResultModel>[];

  Future fetchInvoiceList() async {
    await dbClient.getInvoiceList().then((value) {
      lst = value;
      notifyListeners();
    });
  }

  Future fetchLastYearInvoiceList() async {
    try {
      await dbClient.getLastYearInvoiceList().then((value) {
        lastYearLst = value;
        notifyListeners();
      });
    } catch (e) {
      // print(e);
    }
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

  getLastYearInvoiceById(int id) async {
    final res = await dbClient.getLastYearInvoiceById(id);
    return res;
  }

  Future<List<InvoiceResultModel>> getInvoiceListBypartyId(int id) async {
    final res = await dbClient.getInvoiceListByPartyId(id);
    return res;
  }

  getInvoiceListOfMonth(int month) async {
    outstandingInvoices.clear();
    bankInvoices = [];
    cashInvoices = [];
    invoices = [];
    int bank = 0, cash = 0;
    final res = await dbClient.getInvoiceListOfMonth(month);
    invoices = res;
    for (var ele in res) {
      if (ele.isCash != 1) {
        amtBank = (bank + ele.netAmount!).toString();
        bank += ele.netAmount!;
        bankInvoices.add(ele);
      } else {
        amtCash = (cash + ele.netAmount!).toString();
        cash += ele.netAmount!;
        cashInvoices.add(ele);
      }
    }
  }

  getOutstandingInvoices() async {
    final res = await dbClient.getInvoiceList();
    for (var ele in res) {
      if (ele.eta!.isNotEmpty &&
          DateTime.now().isAfter(DateTime.parse(ele.eta!))) {
        outstandingInvoices.add(ele);
      }
    }
    // notifyListeners();
  }

  removeETA(InvoiceResultModel invoice) async {
    await dbClient.updateETA(invoice).then((value) {
      fetchInvoiceList();
    });
  }
}

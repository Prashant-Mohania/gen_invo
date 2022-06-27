import 'package:flutter/cupertino.dart';
import 'package:gen_invo/Models/invoice_model.dart';

import '../service/database_service.dart';
import 'invoice_result_model.dart';

class InvoiceChangeNotifier extends ChangeNotifier {
  List<InvoiceResultModel> lst = <InvoiceResultModel>[];
  final DatabaseService dbClient = DatabaseService.instance;

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

  remove(InvoiceModel invoice) async {
    await dbClient.deleteInvoice(invoice).then((value) {
      fetchInvoiceList();
      // lst.remove(invoice);
      // notifyListeners();
    });
  }

  Future<InvoiceResultModel> getInvoiceById(int id) async {
    final res = await dbClient.getInvoiceById(id);
    return res;
  }
}

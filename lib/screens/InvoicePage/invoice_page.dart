import 'package:flutter/material.dart';
import 'package:gen_invo/Models/company_model.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/Models/item_change_notifier.dart';
import 'package:gen_invo/screens/InvoicePage/add_invoice_page.dart';
import 'package:gen_invo/screens/InvoicePage/edit_invoice_page.dart';
import 'package:gen_invo/service/database_service.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:gen_invo/widgets/invoice_search.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/save_file.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late CompanyModel company;

  @override
  void initState() {
    super.initState();
    DatabaseService.instance.getCompanyDetails().then((value) {
      company = value.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invoice"),
          actions: [
            IconButton(
              onPressed: () {
                final temp =
                    Provider.of<InvoiceChangeNotifier>(context, listen: false)
                        .lst;
                Provider.of<ItemChangeNotifier>(context, listen: false).close();
                showSearch(context: context, delegate: InvoiceSearch(temp));
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        // drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            LocalDatabase.getInvoiceCounter("invoiceNo").then((invNo) {
              int temp =
                  Provider.of<InvoiceChangeNotifier>(context, listen: false)
                          .lst
                          .length +
                      1 +
                      invNo;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddInvoice(
                            invoiceNo: temp,
                          )));
            });
          },
        ),
        body: Consumer<InvoiceChangeNotifier>(
          builder: (BuildContext context, invoices, Widget? child) {
            return FutureBuilder(
              future: invoices.fetchInvoiceList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "Something went wrong while fetching data. PLease reopen the app."),
                  );
                }
                if (invoices.lst.isEmpty) {
                  return const Center(
                    child: Text("No Invoices Found"),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  // reverse: true,
                  itemCount: invoices.lst.length,
                  itemBuilder: (context, index) {
                    final invoice = invoices.lst[index];
                    return Card(
                      child: ListTile(
                        tileColor: invoice.id!.isEven
                            ? Colors.white
                            : Colors.grey[200],
                        onTap: () {
                          Provider.of<ItemChangeNotifier>(context,
                                  listen: false)
                              .close();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditInvoicePage(invoice: invoice),
                            ),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${invoice.id!} ${invoice.name ?? "No Name"}",
                              style: TextStyle(
                                color: invoice.eta!.isEmpty ? null : Colors.red,
                              ),
                            ),
                            Text(
                              invoice.isCash == 1 &&
                                      invoice.isUPI == 1 &&
                                      invoice.isCheque == 1
                                  ? "By Cash, UPI and Cheque"
                                  : invoice.isCash == 1 && invoice.isUPI == 1
                                      ? "By Cash and UPI"
                                      : invoice.isUPI == 1 &&
                                              invoice.isCheque == 1
                                          ? "By UPI and Cheque"
                                          : invoice.isCash == 1 &&
                                                  invoice.isCheque == 1
                                              ? "By Cash and Cheque"
                                              : invoice.isCash == 1
                                                  ? "By Cash"
                                                  : invoice.isUPI == 1
                                                      ? "By UPI"
                                                      : invoice.isCheque == 1
                                                          ? "By Cheque"
                                                          : invoice.isRTGS == 1
                                                              ? "By RTGS"
                                                              : "",
                              style: TextStyle(
                                color: invoice.eta!.isEmpty ? null : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${_currencyFormat(invoice.netAmount!)}",
                              style: TextStyle(
                                color: invoice.eta!.isEmpty ? null : Colors.red,
                              ),
                            ),
                            Text(
                              invoice.isAdjusted == 1
                                  ? "Adjusted"
                                  : "Not Adjusted",
                              style: TextStyle(
                                color: invoice.isAdjusted == 1
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(
                              invoice.date!,
                              style: TextStyle(
                                color: invoice.eta!.isEmpty ? null : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        onLongPress: () {
                          deleteConfirm(context).then((value) {
                            if (value) {
                              SaveFile.deleteFile(context,
                                  "${invoice.id}_${invoice.name}", invoice);
                              invoices.remove(invoice);
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> deleteConfirm(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Invoice"),
          content: const Text("Are you sure you want to delete the invoice?"),
          actions: [
            ElevatedButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            ElevatedButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  String _currencyFormat(int value) {
    final format =
        NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 0);
    return format.format(value);
  }
}

import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/Models/item_change_notifier.dart';
import 'package:gen_invo/screens/InvoicePage/add_invoice_page.dart';
import 'package:gen_invo/screens/InvoicePage/edit_invoice_page.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:gen_invo/widgets/invoice_search.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/save_file.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({Key? key}) : super(key: key);

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
                    return Card(
                      child: ListTile(
                        tileColor: invoices.lst[index].eta!.isEmpty
                            ? invoices.lst[index].id!.isEven
                                ? Colors.white
                                : Colors.grey[200]
                            : Colors.grey,
                        onTap: () {
                          Provider.of<ItemChangeNotifier>(context,
                                  listen: false)
                              .close();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditInvoicePage(invoice: invoices.lst[index]),
                            ),
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${invoices.lst[index].id!} ${invoices.lst[index].name ?? "No Name"}"),
                            Text(
                              invoices.lst[index].isCash == 1 &&
                                      invoices.lst[index].isUPI == 1 &&
                                      invoices.lst[index].isCheque == 1
                                  ? "By Cash, UPI and Cheque"
                                  : invoices.lst[index].isCash == 1 &&
                                          invoices.lst[index].isUPI == 1
                                      ? "By Cash and UPI"
                                      : invoices.lst[index].isUPI == 1 &&
                                              invoices.lst[index].isCheque == 1
                                          ? "By UPI and Cheque"
                                          : invoices.lst[index].isCash == 1 &&
                                                  invoices.lst[index]
                                                          .isCheque ==
                                                      1
                                              ? "By Cash and Cheque"
                                              : invoices.lst[index].isCash == 1
                                                  ? "By Cash"
                                                  : invoices.lst[index].isUPI ==
                                                          1
                                                      ? "By UPI"
                                                      : invoices.lst[index]
                                                                  .isCheque ==
                                                              1
                                                          ? "By Cheque"
                                                          : invoices.lst[index]
                                                                      .isRTGS ==
                                                                  1
                                                              ? "By RTGS"
                                                              : "",
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "₹ ${_currencyFormat(invoices.lst[index].netAmount!)}"),
                            Text(
                              invoices.lst[index].isAdjusted == 1
                                  ? "Adjusted"
                                  : "Not Adjusted",
                              style: TextStyle(
                                color: invoices.lst[index].isAdjusted == 1
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            Text(invoices.lst[index].date!),
                          ],
                        ),
                        onLongPress: () {
                          deleteConfirm(context).then((value) {
                            if (value) {
                              SaveFile.deleteFile(
                                  context,
                                  "${invoices.lst[index].id}_${invoices.lst[index].name}",
                                  invoices.lst[index]);
                              invoices.remove(invoices.lst[index]);
                            }
                          });
                        },
                        // leading: IconButton(
                        //   onPressed: () {
                        //     changeAdjusted(context, invoices.lst[index]);
                        //   },
                        //   icon: Icon(invoices.lst[index].isAdjusted == 1
                        //       ? Icons.done
                        //       : Icons.close),
                        // ),
                        // trailing: IconButton(
                        //   onPressed: () {
                        //     deleteConfirm(context).then((value) {
                        //       if (value) {
                        //         SaveFile.deleteFile(
                        //             context,
                        //             "${invoices.lst[index].id}_${invoices.lst[index].name}",
                        //             invoices.lst[index]);
                        //         invoices.remove(invoices.lst[index]);
                        //       }
                        //     });
                        //   },
                        //   icon: const Icon(Icons.delete),
                        // ),
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

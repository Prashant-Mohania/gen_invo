import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/screens/InvoicePage/add_invoice_page.dart';
import 'package:gen_invo/screens/InvoicePage/edit_invoice_page.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:gen_invo/widgets/my_drawer.dart';
import 'package:gen_invo/widgets/invoice_search.dart';
import 'package:provider/provider.dart';

import '../../Models/invoice_result_model.dart';

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
                showSearch(context: context, delegate: InvoiceSearch(temp));
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        drawer: const MyDrawer(),
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
                  itemCount: invoices.lst.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditInvoicePage(invoice: invoices.lst[index]),
                            ),
                          );
                        },
                        title: Text(
                            "${invoices.lst[index].id!} ${invoices.lst[index].name ?? "No Name"}"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("₹ ${invoices.lst[index].netAmount!}"),
                            Text("${invoices.lst[index].date!}"),
                          ],
                        ),
                        // leading: IconButton(
                        //   onPressed: () {
                        //     changeAdjusted(context, invoices.lst[index]);
                        //   },
                        //   icon: Icon(invoices.lst[index].isAdjusted == 1
                        //       ? Icons.done
                        //       : Icons.close),
                        // ),
                        trailing: IconButton(
                          onPressed: () {
                            deleteConfirm(context).then((value) {
                              if (value) {
                                invoices.remove(invoices.lst[index]);
                              }
                            });
                          },
                          icon: const Icon(Icons.delete),
                        ),
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
}

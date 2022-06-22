import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/screens/InvoicePage/add_invoice_page.dart';
import 'package:gen_invo/screens/InvoicePage/invoice_view.dart';
import 'package:gen_invo/widgets/my_drawer.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invoice"),
        ),
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            int temp =
                Provider.of<InvoiceChangeNotifier>(context, listen: false)
                        .lst
                        .length +
                    1;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddInvoice(
                          invoiceNo: temp,
                        )));
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
                              builder: (_) => InvoiceView(
                                  invoiceId: invoices.lst[index].id!),
                            ),
                          );
                        },
                        title: Text(
                            "${invoices.lst[index].id!}_${invoices.lst[index].name!}"),
                        subtitle:
                            Text(invoices.lst[index].netBalance!.toString()),
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
}

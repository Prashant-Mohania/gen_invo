import 'package:flutter/material.dart';
import 'package:gen_invo/Models/company_model.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/constants/constants.dart';
import 'package:gen_invo/screens/HomePage/invoices_list.dart';
import 'package:gen_invo/service/database_service.dart';
import 'package:gen_invo/widgets/my_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          title: const Text('Home'),
        ),
        drawer: const MyDrawer(),
        body: Consumer<InvoiceChangeNotifier>(
          builder: (context, value, child) {
            value.getOutstandingInvoices();
            return FutureBuilder(
              future: value.getInvoiceListOfMonth(DateTime.now().month),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "Something went wrong while fetching data. PLease reopen the app."),
                  );
                }

                return SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text("Sale of the month",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        Text(monthNames[DateTime.now().month - 1],
                            style: const TextStyle(fontSize: 30)),
                        const SizedBox(height: 10),
                        Table(
                          border: TableBorder.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Bank', textScaleFactor: 1.6),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        _currencyFormat(
                                            int.parse(value.amtBank)),
                                        textScaleFactor: 1.4),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Cash', textScaleFactor: 1.6),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        _currencyFormat(
                                            int.parse(value.amtCash)),
                                        textScaleFactor: 1.4),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Total', textScaleFactor: 1.6),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        _currencyFormat(int.parse(value.amt)),
                                        textScaleFactor: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoicesList(
                                    title: "Total Invoices",
                                    invoices: value.invoices),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "Total Invoice :",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const Spacer(),
                                  Text(value.invoices.length.toString(),
                                      style: const TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoicesList(
                                    title: "Bank Invoices",
                                    invoices: value.bankInvoices),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "Bank Invoice :",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const Spacer(),
                                  Text(value.bankInvoices.length.toString(),
                                      style: const TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvoicesList(
                                    title: "Cash Invoices",
                                    invoices: value.cashInvoices),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "Cash Invoice :",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const Spacer(),
                                  Text(value.cashInvoices.length.toString(),
                                      style: const TextStyle(fontSize: 20)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(thickness: 2, color: Colors.black),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            "All Outstandings :",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...value.outstandingInvoices.map((e) {
                          return Card(
                            child: ListTile(
                              onLongPress: () async {
                                var res = await updateConfirm(context);
                                if (res) {
                                  e.eta = "";
                                  value.removeETA(e);
                                }
                              },
                              onTap: () {
                                // WhatsappShare.share(
                                //     phone: "91${e.mobile}",
                                //     text:
                                //         "Dear Customer\n\nThis is kindly reminder of invoice no. ${e.id} shows an oustanding balance of ₹${e.netBalance} of date ${e.eta}.\n\nPlease make the payment as soon as possible. If you already paid, contact to us.\n\nFrom:-\n\nRegards\n${company.name}");
                                launchUrlString(
                                  "https://wa.me/91${e.mobile}?text=Dear Customer\n\nThis is kindly reminder of invoice no. ${e.id} shows an oustanding balance of ₹${e.netBalance} of date ${e.eta}.\n\nPlease make the payment as soon as possible. If you already paid, contact to us.\n\nFrom:-\nJL AGRA",
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              title: Text("${e.id} - ${e.name!}"),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.date!),
                                  Text("eta:- ${e.eta!}"),
                                ],
                              ),
                              trailing: Text(_currencyFormat(
                                  int.parse(e.netBalance.toString()))),
                            ),
                          );
                        }).toList()
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<bool> updateConfirm(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Invoice"),
          content: const Text("Are you sure you want to update the invoice?"),
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
        NumberFormat.currency(locale: "HI", symbol: "₹ ", decimalDigits: 0);
    return format.format(value);
  }
}

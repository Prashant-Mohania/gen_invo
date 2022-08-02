import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/constants/constants.dart';
import 'package:gen_invo/widgets/my_drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
            return FutureBuilder(
              future: value.getInvoiceListOfMonth(DateTime.now().month),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        "Something went wrong while fetching data. PLease reopen the app."),
                  );
                }

                return Card(
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

  String _currencyFormat(int value) {
    final format =
        NumberFormat.currency(locale: "HI", symbol: "₹ ", decimalDigits: 0);
    return format.format(value);
  }
}
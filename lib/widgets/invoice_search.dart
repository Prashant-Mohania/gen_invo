import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_result_model.dart';
import 'package:intl/intl.dart';

import '../screens/InvoicePage/edit_invoice_page.dart';
import '../screens/InvoicePage/invoice_view.dart';
import '../utils/save_file.dart';

class InvoiceSearch extends SearchDelegate {
  final List<InvoiceResultModel> invoices;

  InvoiceSearch(this.invoices);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<InvoiceResultModel> suggestionList = query.isEmpty
        ? invoices
        : invoices.where((element) {
            return (element.name ?? "No Name")
                    .toLowerCase()
                    .startsWith(query.toLowerCase()) ||
                element.city!.toLowerCase().startsWith(query.toLowerCase()) ||
                element.id!.toString().startsWith(query.toLowerCase());
          }).toList();
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return suggestionList.isNotEmpty
              ? Card(
                  child: ListTile(
                    title: Text(
                        "${suggestionList[index].id!}_${suggestionList[index].name ?? "No Name"}"),
                    subtitle:
                        Text(suggestionList[index].netBalance!.toString()),
                    trailing: Text(suggestionList[index].date!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              InvoiceView(invoiceId: suggestionList[index].id!),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("No Data"),
                );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<InvoiceResultModel> suggestionList = query.isEmpty
        ? invoices
        : invoices.where((element) {
            return (element.name ?? "No Name")
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element.city!.toLowerCase().contains(query.toLowerCase()) ||
                element.state!.toString().contains(query.toLowerCase());
          }).toList();
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return suggestionList.isNotEmpty
              ? Card(
                  child: ListTile(
                    tileColor: suggestionList[index].id!.isEven
                        ? Colors.white
                        : Colors.grey[200],
                    // title: Text(
                    //     "${suggestionList[index].id!} ${suggestionList[index].name ?? "No Name"}"),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${suggestionList[index].id!} ${suggestionList[index].name ?? "No Name"}"),
                        Text(
                          suggestionList[index].isCash == 1 &&
                                  suggestionList[index].isUPI == 1 &&
                                  suggestionList[index].isCheque == 1
                              ? "By Cash, UPI and Cheque"
                              : suggestionList[index].isCash == 1 &&
                                      suggestionList[index].isUPI == 1
                                  ? "By Cash and UPI"
                                  : suggestionList[index].isUPI == 1 &&
                                          suggestionList[index].isCheque == 1
                                      ? "By UPI and Cheque"
                                      : suggestionList[index].isCash == 1 &&
                                              suggestionList[index].isCheque ==
                                                  1
                                          ? "By Cash and Cheque"
                                          : suggestionList[index].isCash == 1
                                              ? "By Cash"
                                              : suggestionList[index].isUPI == 1
                                                  ? "By UPI"
                                                  : "By Cheque",
                        ),
                      ],
                    ),
                    // subtitle:
                    //     Text(suggestionList[index].netBalance!.toString()),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "₹ ${_currencyFormat(suggestionList[index].netAmount!)}"),
                        Text(suggestionList[index].date!),
                      ],
                    ),
                    onLongPress: () {
                      deleteConfirm(context).then((value) {
                        if (value) {
                          SaveFile.deleteFile(
                              context,
                              "${suggestionList[index].id}_${suggestionList[index].name}",
                              suggestionList[index]);
                          invoices.remove(suggestionList[index]);
                        }
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditInvoicePage(invoice: suggestionList[index]),
                        ),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("No Data"),
                );
        });
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

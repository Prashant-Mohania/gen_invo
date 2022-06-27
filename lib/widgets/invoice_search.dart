import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_result_model.dart';

import '../screens/InvoicePage/edit_invoice_page.dart';
import '../screens/InvoicePage/invoice_view.dart';

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
                    .startsWith(query.toLowerCase()) ||
                element.city!.toLowerCase().startsWith(query.toLowerCase()) ||
                element.id!.toString().startsWith(query.toLowerCase()) ||
                element.date!.toString().contains(query.toLowerCase());
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
}

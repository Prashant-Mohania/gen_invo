import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_result_model.dart';
import 'package:provider/provider.dart';

import '../../Models/invoice_change_notifier.dart';
import '../../Models/party_model.dart';

class PartyInvoicePage extends StatelessWidget {
  final PartyModel party;
  const PartyInvoicePage({Key? key, required this.party}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(party.name!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<InvoiceResultModel>>(
            future: Provider.of<InvoiceChangeNotifier>(context, listen: false)
                .getInvoiceListBypartyId(party.partyId!),
            builder:
                ((context, AsyncSnapshot<List<InvoiceResultModel>> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                      "Something went wrong while fetching data. PLease reopen the app."),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Invoices Found"),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => PartyDetailsPage(
                      //               party: party.lst[index],
                      //             )));
                    },
                    title: Text(
                        "${snapshot.data![index].id}_${snapshot.data![index].name ?? "No Name"}"),
                    subtitle: Text(snapshot.data![index].netAmount!.toString()),
                    trailing: Text(snapshot.data![index].date!.toString()),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

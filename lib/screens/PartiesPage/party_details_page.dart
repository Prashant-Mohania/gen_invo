import 'package:flutter/material.dart';
import 'package:gen_invo/Models/party_model.dart';

import '../../widgets/custom_button.dart';
import 'edit_party_page.dart';

class PartyDetailsPage extends StatelessWidget {
  final PartyModel party;
  const PartyDetailsPage({Key? key, required this.party}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Party Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(1.0),
                  1: FlexColumnWidth(2.0),
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Name",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.name!,
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Address",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.address!,
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "GSTIN",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.gst!.toUpperCase(),
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Mobile",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.mobile!,
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Email",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.email!,
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[300]),
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "City",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.city!,
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "State",
                          textScaleFactor: 1.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          party.state!,
                          textScaleFactor: 1.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              CustomButton(
                  text: "Edit",
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditPartyPage(party: party)));
                  })
            ],
          ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       "Name:-  ${party.name!}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Divider(thickness: 1),
          //     Text(
          //       "Mobile:-  ${party.mobile}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Divider(thickness: 1),
          //     Text(
          //       "Address:-  ${party.address}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Divider(thickness: 1),
          //     Text(
          //       "Email:-  ${party.email}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Divider(thickness: 1),
          //     Text(
          //       "City:-  ${party.city}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Divider(thickness: 1),
          //     Text(
          //       "State:-  ${party.state}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          //     const Divider(thickness: 1),
          //     Text(
          //       "GSTIN:-  ${party.gst}",
          //       style: const TextStyle(fontSize: 20),
          //     ),
          // const Spacer(),
          // CustomButton(
          //     text: "Edit",
          //     callback: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (_) => EditPartyPage(party: party)));
          //     })
          //   ],
          // ),
        ),
      ),
    );
  }
}

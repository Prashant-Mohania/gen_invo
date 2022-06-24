import 'package:flutter/material.dart';
import 'package:gen_invo/Models/party_model.dart';
import 'package:gen_invo/widgets/custom_button.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name:-  ${party.name!}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(thickness: 1),
              Text(
                "Mobile:-  ${party.mobile}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(thickness: 1),
              Text(
                "Address:-  ${party.address}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(thickness: 1),
              Text(
                "Email:-  ${party.email}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(thickness: 1),
              Text(
                "City:-  ${party.city}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(thickness: 1),
              Text(
                "State:-  ${party.state}",
                style: const TextStyle(fontSize: 20),
              ),
              const Divider(thickness: 1),
              Text(
                "GSTIN:-  ${party.gst}",
                style: const TextStyle(fontSize: 20),
              ),
              const Spacer(),
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
        ),
      ),
    );
  }
}

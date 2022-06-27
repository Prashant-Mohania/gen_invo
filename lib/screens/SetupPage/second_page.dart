import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:gen_invo/MyExtension/my_extention.dart';
import 'package:gen_invo/screens/InvoicePage/invoice_page.dart';
import 'package:gen_invo/service/database_service.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:gen_invo/widgets/custom_button.dart';

import '../../Models/party_model.dart';

class SecondPage extends StatefulWidget {
  final Excel excel;
  const SecondPage({Key? key, required this.excel}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool isAdding = true;
  final DatabaseService _dbClient = DatabaseService.instance;

  addingData() async {
    if (widget.excel.tables[widget.excel.tables.keys.first]!.maxCols == 7) {
      for (var row
          in widget.excel.tables[widget.excel.tables.keys.first]!.rows) {
        if (row[0]!.value.toString().toLowerCase() == "id") continue;

        await _dbClient.insertPartyData(PartyModel(
          partyId: int.tryParse(row[0]!.value.toString().toTitleCase()),
          name: row[1] != null
              ? row[1]!.value.toString().trim().toTitleCase()
              : "",
          gst: row[2] != null
              ? row[2]!.value.toString().trim().toTitleCase()
              : "",
          mobile: row[3] != null
              ? row[3]!.value.toString().trim().toTitleCase()
              : "",
          address: row[4] != null
              ? row[4]!.value.toString().trim().toTitleCase()
              : "",
          city: row[5] != null
              ? row[5]!.value.toString().trim().toTitleCase()
              : "",
          state: row[6] != null
              ? row[6]!.value.toString().trim().toTitleCase()
              : "",
          email: "",
        ));
      }
      await LocalDatabase.setSetup("setup", true);
      setState(() {
        isAdding = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Invalid file format"),
      ));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    addingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isAdding
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text("Adding your party details", textScaleFactor: 2),
                    SizedBox(height: 30),
                    CircularProgressIndicator()
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Party details added successfully",
                        textScaleFactor: 2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      CustomButton(
                          text: "Your Setup Completed",
                          callback: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const InvoicePage()));
                          })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

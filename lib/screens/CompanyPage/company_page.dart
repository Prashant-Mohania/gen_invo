import 'package:flutter/material.dart';
import 'package:gen_invo/Models/company_model.dart';
import 'package:gen_invo/service/database_service.dart';

import 'add_company_page.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Company Details"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            future: DatabaseService.instance.getCompanyDetails(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                      "Something went wrong while fetching data. PLease reopen the app."),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: InkWell(
                    onTap: () async {
                      final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddCompanyPage())) ??
                          false;
                      if (res) {
                        setState(() {});
                      }
                    },
                    child: const Text(
                      "Not Company added yet\nAdd now",
                      textScaleFactor: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name:-  ${snapshot.data![0].name}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "GST Number:-  ${snapshot.data![0].gstNumber}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "Phone Number:-  ${snapshot.data![0].phoneNumber}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "Address:-  ${snapshot.data![0].address}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "City:-  ${snapshot.data![0].city}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "State:-  ${snapshot.data![0].state}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "State Code:-  ${snapshot.data![0].stateCode}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "Bank Name:-  ${snapshot.data![0].bankName}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "IFSC Code:-  ${snapshot.data![0].ifscCode}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "Account Number:-  ${snapshot.data![0].accountNumber}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Divider(thickness: 1),
                  Text(
                    "Bank Address:-  ${snapshot.data![0].bankAddress}",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

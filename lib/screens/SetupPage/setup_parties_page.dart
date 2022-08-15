import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gen_invo/screens/HomePage/home_page.dart';
import 'package:gen_invo/screens/SetupPage/second_page.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:gen_invo/utils/save_file.dart';

import '../../widgets/custom_button.dart';

class SetupPartiesPage extends StatelessWidget {
  const SetupPartiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Setup Parties",
                textScaleFactor: 4,
              ),
              const SizedBox(height: 40),
              CustomButton(
                callback: () async {
                  if (await SaveFile().requestPermission()) {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                            type: FileType.custom,
                            allowMultiple: false,
                            allowedExtensions: ["xlsx"]);
                    if (result != null) {
                      var bytes =
                          File(result.files.single.path!).readAsBytesSync();
                      var excel = Excel.decodeBytes(bytes);
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SecondPage(excel: excel)));
                    }
                  }
                },
                text: "Select Excel File",
              ),
              const SizedBox(height: 10),
              CustomButton(
                callback: () {
                  LocalDatabase.setSetup("setup", true);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
                text: "Skip",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

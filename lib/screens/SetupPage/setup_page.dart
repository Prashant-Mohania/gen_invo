import 'package:flutter/material.dart';
import 'package:gen_invo/screens/CompanyPage/company_page.dart';
import 'package:gen_invo/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Image.asset("images/icon.png"),
              const Spacer(),
              InkWell(
                onTap: () async {
                  if (await canLaunchUrlString("https://www.atf-labs.com")) {
                    await launchUrlString("https://www.atf-labs.com");
                  }
                },
                child: const Text(
                  "Made By ATF-LABS",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                callback: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const CompanyPage()));
                },
                text: "Start Setup",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

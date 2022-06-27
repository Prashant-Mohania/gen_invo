import 'package:flutter/material.dart';
import 'package:gen_invo/Models/party_change_notifier.dart';
import 'package:gen_invo/Models/party_model.dart';
import 'package:gen_invo/MyExtension/my_extention.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/state_dialog.dart';

class AddPartyPage extends StatefulWidget {
  const AddPartyPage({Key? key}) : super(key: key);

  @override
  State<AddPartyPage> createState() => _AddPartyPageState();
}

class _AddPartyPageState extends State<AddPartyPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Party"),
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Party Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? "required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: numberController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (value.length != 10) {
                          return "Invalid Mobile Number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      validator: (val) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!);
                        if (!emailValid && val.isNotEmpty) {
                          return "Invalid Email";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'city',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? "required" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: stateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value!.isEmpty ? "required" : null,
                      onTap: () async {
                        var res = await showDialog(
                          context: context,
                          builder: (context) {
                            return const StateDialog();
                          },
                        );
                        if (res != null) {
                          stateController.text = res;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: gstController,
                      decoration: const InputDecoration(
                        labelText: 'GST Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      callback: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoad = true;
                          });
                          var party = PartyModel(
                            name: nameController.text.toTitleCase(),
                            mobile: numberController.text.toTitleCase(),
                            email: emailController.text.toTitleCase(),
                            city: cityController.text.toTitleCase(),
                            state: stateController.text.toTitleCase(),
                            gst: gstController.text.toTitleCase(),
                            address: addressController.text.toTitleCase(),
                          );
                          Provider.of<PartyChangeNotifier>(context,
                                  listen: false)
                              .add(party)
                              .then((value) {
                            setState(() {
                              isLoad = false;
                            });
                            Navigator.pop(context);
                          }).catchError((onError) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("Something went wrong!!! try again"),
                            ));
                            setState(() {
                              isLoad = false;
                            });
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ),
    );
  }
}

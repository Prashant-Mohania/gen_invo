import 'package:flutter/material.dart';
import 'package:gen_invo/Models/party_change_notifier.dart';
import 'package:gen_invo/Models/party_model.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/state_dialog.dart';

class EditPartyPage extends StatefulWidget {
  final PartyModel party;
  const EditPartyPage({Key? key, required this.party}) : super(key: key);

  @override
  State<EditPartyPage> createState() => _EditPartyPageState();
}

class _EditPartyPageState extends State<EditPartyPage> {
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
  void initState() {
    nameController.text = widget.party.name!;
    numberController.text = widget.party.mobile!;
    emailController.text = widget.party.email!;
    cityController.text = widget.party.city!;
    stateController.text = widget.party.state!;
    gstController.text = widget.party.gst!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Party"),
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
                            partyId: widget.party.partyId,
                            name: nameController.text,
                            mobile: numberController.text,
                            email: emailController.text,
                            city: cityController.text,
                            state: stateController.text,
                            gst: gstController.text,
                            address: addressController.text,
                          );
                          Provider.of<PartyChangeNotifier>(context,
                                  listen: false)
                              .update(party)
                              .then((value) {
                            setState(() {
                              isLoad = false;
                            });
                            Navigator.pop(context);
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

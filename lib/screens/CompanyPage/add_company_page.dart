import 'package:flutter/material.dart';
import 'package:gen_invo/Models/company_model.dart';
import 'package:gen_invo/MyExtension/my_extention.dart';
import 'package:gen_invo/service/local_database.dart';
import 'package:gen_invo/widgets/custom_button.dart';

import '../../service/database_service.dart';
import '../../widgets/state_dialog.dart';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({Key? key}) : super(key: key);

  @override
  State<AddCompanyPage> createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _stateCodeController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankAddressController = TextEditingController();
  final TextEditingController _invoiceNoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Firm"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: "Company Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _gstNumberController,
                  decoration: const InputDecoration(
                    labelText: "GST Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneNumberController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: "City",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _stateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "State",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  onTap: () async {
                    var res = await showDialog(
                      context: context,
                      builder: (context) {
                        return const StateDialog();
                      },
                    );
                    if (res != null) {
                      _stateController.text = res;
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _stateCodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "State Code",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _bankNameController,
                  decoration: const InputDecoration(
                    labelText: "Bank Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ifscCodeController,
                  decoration: const InputDecoration(
                    labelText: "IFSC CODE",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Account Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _bankAddressController,
                  decoration: const InputDecoration(
                    labelText: "Bank Address",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _invoiceNoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Invoice Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                    callback: () {
                      if (_formKey.currentState!.validate()) {
                        DatabaseService.instance
                            .insertCompanyData(
                          CompanyModel(
                            name: _companyNameController.text.toTitleCase(),
                            gstNumber: _gstNumberController.text.toTitleCase(),
                            phoneNumber:
                                int.tryParse(_phoneNumberController.text),
                            address: _addressController.text.toTitleCase(),
                            city: _cityController.text.toTitleCase(),
                            state: _stateController.text.toTitleCase(),
                            stateCode: int.tryParse(_stateCodeController.text),
                            bankName: _bankNameController.text.toTitleCase(),
                            ifscCode: _ifscCodeController.text,
                            accountNumber:
                                int.tryParse(_accountNumberController.text),
                            bankAddress:
                                _bankAddressController.text.toTitleCase(),
                          ),
                        )
                            .then((value) {
                          LocalDatabase.setInvoiceCounter("invoiceNo",
                              int.tryParse(_invoiceNoController.text)!);
                          Navigator.pop(context, true);
                        }).catchError((err) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Error Occured"),
                          ));
                        });
                      }
                    },
                    text: "Add Company"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

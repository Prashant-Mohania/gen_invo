import 'package:flutter/material.dart';
import 'package:gen_invo/Models/item_model.dart';
import 'package:gen_invo/MyExtension/my_extention.dart';
import 'package:provider/provider.dart';

import '../../Models/item_change_notifier.dart';
import '../../widgets/custom_button.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController hsnController = TextEditingController();

  bool isLoad = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Item'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: hsnController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'HSN Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  callback: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        isLoad = true;
                      });

                      Provider.of<ItemChangeNotifier>(context, listen: false)
                          .add(ItemModel(
                        title: nameController.text.toTitleCase(),
                        hsn: int.tryParse(hsnController.text),
                        isDefault: 0,
                      ))
                          .then((value) {
                        setState(() {
                          isLoad = false;
                        });
                        Navigator.pop(context);
                      }).catchError((onError) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Something went wrong!!! try again"),
                        ));
                        setState(() {
                          isLoad = false;
                        });
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

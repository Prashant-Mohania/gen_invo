import 'package:flutter/material.dart';
import 'package:gen_invo/Models/item_model.dart';
import 'package:provider/provider.dart';

import '../../Models/item_change_notifier.dart';
import '../../widgets/custom_button.dart';

class EditItemPage extends StatefulWidget {
  final ItemModel item;
  const EditItemPage({Key? key, required this.item}) : super(key: key);

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController hsnController = TextEditingController();

  bool isLoad = false;

  @override
  void initState() {
    nameController.text = widget.item.title!;
    hsnController.text = widget.item.hsn!.toString();
    super.initState();
  }

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
                  text: "Edit Item",
                  callback: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        isLoad = true;
                      });

                      Provider.of<ItemChangeNotifier>(context, listen: false)
                          .update(ItemModel(
                        itemId: widget.item.itemId,
                        title: nameController.text,
                        hsn: int.tryParse(hsnController.text),
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

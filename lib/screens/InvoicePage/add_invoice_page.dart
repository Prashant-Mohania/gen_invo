import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/Models/invoice_model.dart';
import 'package:gen_invo/Models/party_model.dart';
import 'package:gen_invo/MyExtension/my_extention.dart';
import 'package:gen_invo/screens/InvoicePage/invoice_view.dart';
import 'package:gen_invo/service/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Models/item_change_notifier.dart';
import '../../Models/item_model.dart';
import '../../Models/party_change_notifier.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/my_search_delegate.dart';
import '../../widgets/state_dialog.dart';

enum PartyType { regular, nonRegular }

class AddInvoice extends StatefulWidget {
  final int invoiceNo;
  const AddInvoice({Key? key, required this.invoiceNo}) : super(key: key);

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController partyNameController = TextEditingController();
  TextEditingController subTotalController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController csgtController = TextEditingController();
  TextEditingController scgstController = TextEditingController();
  TextEditingController igstController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController roundOffController = TextEditingController();
  TextEditingController finalAmountController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController totalCostController = TextEditingController();
  TextEditingController cashAmountController = TextEditingController();
  TextEditingController upiAmountController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController chequeAmountController = TextEditingController();
  TextEditingController chequeNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoad = false, isCash = false, isUPI = false, isCheque = false;
  late ItemModel defaultItem;
  late PartyModel selectedParty;
  late List<ItemModel> itemList;
  PartyType partyType = PartyType.regular;

  Future<void> itemDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white.withAlpha(200),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        defaultItem = itemList[index];

                        setState(() {});
                        Navigator.pop(context);
                      },
                      title: Text("${itemList[index].title}"),
                      subtitle: Text("hsn : ${itemList[index].hsn}"),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    Provider.of<ItemChangeNotifier>(context, listen: false)
        .fetchItemList()
        .then((value) {
      itemList = Provider.of<ItemChangeNotifier>(context, listen: false).lst;
      selectedParty = PartyModel();
      defaultItem = ItemModel(title: "");
      for (var element in itemList) {
        if (element.isDefault == 1) {
          defaultItem = element;
        }
      }
    });
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    invoiceNoController.text = widget.invoiceNo.toString();
    discountController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    dateController.dispose();
    invoiceNoController.dispose();
    partyNameController.dispose();
    subTotalController.dispose();
    totalAmountController.dispose();
    csgtController.dispose();
    scgstController.dispose();
    igstController.dispose();
    discountController.dispose();
    roundOffController.dispose();
    finalAmountController.dispose();
    balanceController.dispose();
    weightController.dispose();
    rateController.dispose();
    totalCostController.dispose();
    cashAmountController.dispose();
    upiAmountController.dispose();
    selectedParty = selectedParty;
    defaultItem = defaultItem;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Invoice'),
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: invoiceNoController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: "Invoice No.",
                                labelText: "Invoice No.",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: dateController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: "Invoice Date",
                                labelText: "Invoice Date",
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async {
                                DateTime res = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                    ) ??
                                    DateTime.now();
                                dateController.text =
                                    DateFormat('dd-MM-yyyy').format(res);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Client Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Regular Client"),
                          Switch(
                              value: PartyType.regular == partyType,
                              onChanged: (val) {
                                setState(() {
                                  partyType = val
                                      ? PartyType.regular
                                      : PartyType.nonRegular;
                                });
                              }),
                        ],
                      ),
                      const SizedBox(height: 10),
                      partyType == PartyType.regular
                          ? TextFormField(
                              controller: partyNameController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: "Name / city",
                                border: OutlineInputBorder(),
                              ),
                              onTap: () async {
                                PartyChangeNotifier party =
                                    Provider.of<PartyChangeNotifier>(
                                  context,
                                  listen: false,
                                );
                                final items = Provider.of<ItemChangeNotifier>(
                                    context,
                                    listen: false);

                                await party.fetchPartyList();

                                var res = await showSearch(
                                      context: context,
                                      delegate: MySearch(
                                        lst: party.lst,
                                      ),
                                    ) ??
                                    PartyModel();
                                if (res.partyId != null) {
                                  selectedParty = res;
                                  partyNameController.text =
                                      "${res.name!} / ${res.city!}";

                                  double tax =
                                      selectedParty.state == "Uttar Pradesh"
                                          ? items.taxCalculation()
                                          : 0.0;
                                  subTotalController.text =
                                      totalCostController.text;
                                  csgtController.text = tax.toStringAsFixed(2);
                                  scgstController.text = tax.toStringAsFixed(2);

                                  double igst =
                                      selectedParty.state != "Uttar Pradesh"
                                          ? items.igstCalculation()
                                          : 0.0;
                                  igstController.text = igst.toStringAsFixed(2);
                                }
                              },
                            )
                          : Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) {
                                    if (partyType == PartyType.regular) {
                                      return null;
                                    } else if (val!.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Name",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedParty.name = val;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: cityController,
                                  validator: (val) {
                                    if (partyType == PartyType.regular) {
                                      return null;
                                    } else if (val!.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "city",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedParty.city = val;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: stateController,
                                  readOnly: true,
                                  validator: (val) {
                                    if (partyType == PartyType.regular) {
                                      return null;
                                    } else if (val!.isEmpty) {
                                      return "Required";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "State",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () async {
                                    var res = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const StateDialog();
                                      },
                                    );
                                    if (res != null) {
                                      stateController.text = res;
                                      setState(() {
                                        selectedParty.state = res;
                                      });
                                    }
                                  },
                                ),
                                // const SizedBox(height: 20),
                                // CustomButton(
                                //   text: "Add Party",
                                //   callback: () {
                                //     if (nameController.text.isNotEmpty &&
                                //         cityController.text.isNotEmpty &&
                                //         stateController.text.isNotEmpty) {
                                //       DatabaseService.instance
                                //           .insertPartyData(PartyModel(
                                //         name: nameController.text,
                                //         city: cityController.text,
                                //         state: stateController.text,
                                //       ))
                                //           .then((value) {
                                //         partyNameController.text =
                                //             "${value.name!} / ${value.city!}";
                                //         setState(() {
                                //           selectedParty = value;
                                //           partyType = PartyType.regular;
                                //           nameController.text = "";
                                //           cityController.text = "";
                                //           stateController.text = "";
                                //         });
                                //       });
                                //     }
                                //   },
                                // )
                              ],
                            ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const Text(
                        "Invoice Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Items",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<ItemChangeNotifier>(
                        builder: (BuildContext context, value, Widget? child) {
                          if (value.lst.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              child: const Text("No Items"),
                            );
                          }
                          if (defaultItem.title!.isEmpty) {
                            return InkWell(
                              onTap: () {
                                itemDialog();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: const Text("No Default Items selected"),
                              ),
                            );
                          }
                          return Card(
                            child: ListTile(
                              onTap: () {
                                itemDialog();
                              },
                              title: Text(
                                "${defaultItem.title!} / ${defaultItem.hsn!}",
                              ),
                              trailing: const Icon(Icons.expand_more),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Consumer<ItemChangeNotifier>(
                          builder: (context, items, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: weightController,
                                validator: (val) =>
                                    val!.isEmpty ? "Enter Weight" : null,
                                decoration: const InputDecoration(
                                  hintText: "weight in gm",
                                ),
                                onChanged: (val) {
                                  double weight = val.isNotEmpty
                                      ? double.parse(weightController.text)
                                      : 0.0;
                                  double rate = rateController.text.isNotEmpty
                                      ? double.tryParse(rateController.text)!
                                      : 0.0;

                                  double subAmnt = items
                                      .subTotalAmount(weight * rate / 1000);
                                  totalCostController.text =
                                      subAmnt.toStringAsFixed(2);

                                  double tax =
                                      selectedParty.state == "Uttar Pradesh"
                                          ? items.taxCalculation()
                                          : 0.0;
                                  subTotalController.text =
                                      totalCostController.text;
                                  csgtController.text = tax.toStringAsFixed(2);
                                  scgstController.text = tax.toStringAsFixed(2);

                                  double igst =
                                      selectedParty.state != "Uttar Pradesh"
                                          ? items.igstCalculation()
                                          : 0.0;
                                  igstController.text = igst.toStringAsFixed(2);

                                  totalAmountController.text =
                                      items.totalAmount().toStringAsFixed(2);

                                  roundOffController.text =
                                      items.roundOff().toStringAsFixed(2);
                                  finalAmountController.text =
                                      items.finalAmount().toStringAsFixed(0);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: rateController,
                                validator: (val) =>
                                    val!.isEmpty ? "Enter Rate" : null,
                                decoration: const InputDecoration(
                                  hintText: "Rate in kg",
                                ),
                                onChanged: (val) {
                                  double weight =
                                      weightController.text.isNotEmpty
                                          ? double.parse(weightController.text)
                                          : 0.0;
                                  double rate = val.isNotEmpty
                                      ? double.tryParse(rateController.text)!
                                      : 0.0;

                                  double subAmnt = items
                                      .subTotalAmount(weight * rate / 1000);
                                  totalCostController.text =
                                      subAmnt.toStringAsFixed(2);

                                  double tax =
                                      selectedParty.state == "Uttar Pradesh"
                                          ? items.taxCalculation()
                                          : 0.0;
                                  subTotalController.text =
                                      totalCostController.text;
                                  csgtController.text = tax.toStringAsFixed(2);
                                  scgstController.text = tax.toStringAsFixed(2);

                                  double igst =
                                      selectedParty.state != "Uttar Pradesh"
                                          ? items.igstCalculation()
                                          : 0.0;
                                  igstController.text = igst.toStringAsFixed(2);

                                  totalAmountController.text =
                                      items.totalAmount().toStringAsFixed(2);

                                  roundOffController.text =
                                      items.roundOff().toStringAsFixed(2);
                                  finalAmountController.text =
                                      items.finalAmount().toStringAsFixed(0);
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: totalCostController,
                                decoration: const InputDecoration(
                                  hintText: "Total Cost",
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isCash,
                                        onChanged: (bool? val) {
                                          setState(() {
                                            isCash = val!;
                                          });
                                        },
                                      ),
                                      const Text("Cash")
                                    ],
                                  ),
                                  TextFormField(
                                    readOnly: !isCash,
                                    keyboardType: TextInputType.number,
                                    controller: cashAmountController,
                                    validator: (val) => (val!.isEmpty && isCash)
                                        ? "Required"
                                        : null,
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isUPI,
                                        onChanged: (bool? val) {
                                          setState(() {
                                            isUPI = val!;
                                          });
                                        },
                                      ),
                                      const Text("UPI")
                                    ],
                                  ),
                                  TextFormField(
                                    readOnly: !isUPI,
                                    keyboardType: TextInputType.number,
                                    validator: (val) => (val!.isEmpty && isUPI)
                                        ? "Required"
                                        : null,
                                    controller: upiAmountController,
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isCheque,
                                        onChanged: (bool? val) {
                                          setState(() {
                                            isCheque = val!;
                                          });
                                        },
                                      ),
                                      const Text("Cheque")
                                    ],
                                  ),
                                  TextFormField(
                                    readOnly: !isCheque,
                                    validator: (val) =>
                                        (val!.isEmpty && isCheque)
                                            ? "Required"
                                            : null,
                                    controller: bankNameController,
                                    decoration: const InputDecoration(
                                      hintText: "Bank Name",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: !isCheque,
                                    keyboardType: TextInputType.number,
                                    validator: (val) =>
                                        (val!.isEmpty && isCheque)
                                            ? "Required"
                                            : null,
                                    controller: chequeNumberController,
                                    decoration: const InputDecoration(
                                      hintText: "Cheque Number",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    readOnly: !isCheque,
                                    keyboardType: TextInputType.number,
                                    validator: (val) =>
                                        (val!.isEmpty && isCheque)
                                            ? "Required"
                                            : null,
                                    controller: chequeAmountController,
                                    decoration: const InputDecoration(
                                      hintText: "Amount",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: subTotalController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "Sub Total",
                                    labelText: "Sub Total",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: csgtController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "CGST",
                                    labelText: "CGST",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: scgstController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "SGST",
                                    labelText: "SGST",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: igstController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "IGST",
                                    labelText: "IGST",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: totalAmountController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "Total Amount",
                                    labelText: "Total Amount",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: discountController,
                                  decoration: const InputDecoration(
                                    hintText: "Discount",
                                    labelText: "Discount",
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (val) {
                                    ItemChangeNotifier items =
                                        Provider.of<ItemChangeNotifier>(context,
                                            listen: false);
                                    items
                                        .discountAmount(val.isNotEmpty
                                            ? double.tryParse(val)!
                                            : 0.0)
                                        .toStringAsFixed(2);
                                    finalAmountController.text =
                                        items.finalAmount().toStringAsFixed(0);
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: roundOffController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "RoundOff",
                                    labelText: "RoundOff",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: finalAmountController,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    hintText: "Final Amount",
                                    labelText: "Final Amount",
                                    border: OutlineInputBorder(),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          text: "Generate Invoice",
                          callback: () async {
                            var id = selectedParty.partyId;
                            if (partyType == PartyType.nonRegular) {
                              if (nameController.text.isNotEmpty &&
                                  cityController.text.isNotEmpty &&
                                  stateController.text.isNotEmpty) {
                                final res = await DatabaseService.instance
                                    .insertPartyData(PartyModel(
                                  name: nameController.text.toTitleCase(),
                                  city: cityController.text.toTitleCase(),
                                  state: stateController.text.toTitleCase(),
                                  email: "",
                                  mobile: "",
                                  gst: "",
                                  address: "",
                                ));
                                partyNameController.text =
                                    "${res.name!} / ${res.city!}";
                                id = res.partyId;
                              }
                            }
                            if (_formKey.currentState!.validate()) {
                              InvoiceModel invoice = InvoiceModel(
                                id: widget.invoiceNo,
                                pId: id,
                                iId: defaultItem.itemId,
                                date: dateController.text,
                                weightInGrams:
                                    double.tryParse(weightController.text)!,
                                ratePerGram:
                                    double.tryParse(rateController.text)! /
                                        1000,
                                totalCost:
                                    double.tryParse(totalCostController.text)!,
                                cgst: double.tryParse(csgtController.text)!,
                                sgst: double.tryParse(scgstController.text)!,
                                igst: double.tryParse(igstController.text)!,
                                totalAmountWithoutRounding:
                                    double.tryParse(totalAmountController.text),
                                totalAmountWithRounding:
                                    int.tryParse(finalAmountController.text)!,
                                discount:
                                    int.tryParse(discountController.text) ?? 0,
                                netAmount:
                                    int.tryParse(finalAmountController.text)!,
                                isCash: isCash == true ? 1 : 0,
                                receivedInCash:
                                    int.tryParse(cashAmountController.text) ??
                                        0,
                                isUPI: isUPI == true ? 1 : 0,
                                receivedInUPI:
                                    int.tryParse(upiAmountController.text) ?? 0,
                                isCheque: isCheque == true ? 1 : 0,
                                receivedInCheque:
                                    int.tryParse(chequeAmountController.text) ??
                                        0,
                                chequeNumber: chequeNumberController.text,
                                bankName: bankNameController.text,
                              );
                              Provider.of<InvoiceChangeNotifier>(context,
                                      listen: false)
                                  .add(invoice)
                                  .then((value) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => InvoiceView(
                                              invoiceId: invoice.id!,
                                            )));
                              });

                              Provider.of<ItemChangeNotifier>(context,
                                      listen: false)
                                  .close();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

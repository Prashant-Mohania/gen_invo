import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_result_model.dart';
import 'package:intl/intl.dart';

class InvoicesList extends StatelessWidget {
  final String title;
  final List<InvoiceResultModel> invoices;
  const InvoicesList({Key? key, required this.title, required this.invoices})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                tileColor: invoices[index].id!.isEven
                    ? Colors.white
                    : Colors.grey[200],
                // onTap: () {
                //   Provider.of<ItemChangeNotifier>(context, listen: false)
                //       .close();
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) =>
                //           EditInvoicePage(invoice: invoices[index]),
                //     ),
                //   );
                // },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${invoices[index].id!} ${invoices[index].name ?? "No Name"}"),
                    Text(
                      invoices[index].isCash == 1 &&
                              invoices[index].isUPI == 1 &&
                              invoices[index].isCheque == 1
                          ? "By Cash, UPI and Cheque"
                          : invoices[index].isCash == 1 &&
                                  invoices[index].isUPI == 1
                              ? "By Cash and UPI"
                              : invoices[index].isUPI == 1 &&
                                      invoices[index].isCheque == 1
                                  ? "By UPI and Cheque"
                                  : invoices[index].isCash == 1 &&
                                          invoices[index].isCheque == 1
                                      ? "By Cash and Cheque"
                                      : invoices[index].isCash == 1
                                          ? "By Cash"
                                          : invoices[index].isUPI == 1
                                              ? "By UPI"
                                              : invoices[index].isCheque == 1
                                                  ? "By Cheque"
                                                  : invoices[index].isRTGS == 1
                                                      ? "By RTGS"
                                                      : "",
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹ ${_currencyFormat(invoices[index].netAmount!)}"),
                    Text(
                      invoices[index].isAdjusted == 1
                          ? "Adjusted"
                          : "Not Adjusted",
                      style: TextStyle(
                        color: invoices[index].isAdjusted == 1
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    Text(invoices[index].date!),
                  ],
                ),
              ),
            );
          },
          itemCount: invoices.length,
        ),
      ),
    );
  }

  String _currencyFormat(int value) {
    final format =
        NumberFormat.currency(locale: "HI", symbol: "", decimalDigits: 0);
    return format.format(value);
  }
}

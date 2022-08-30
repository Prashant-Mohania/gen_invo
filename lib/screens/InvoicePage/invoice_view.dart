import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/utils/save_file.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../Models/invoice_result_model.dart';
import '../../utils/invoice_generator.dart';

class InvoiceView extends StatefulWidget {
  final int invoiceId;
  const InvoiceView({Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  bool isLoad = true;
  String filePath = "";
  late InvoiceResultModel invoice;

  @override
  void initState() {
    Provider.of<InvoiceChangeNotifier>(context, listen: false)
        .getInvoiceById(widget.invoiceId)
        .then((value) {
      invoice = value;
      SaveFile.saveFile(context, "${invoice.id}_${invoice.name}", invoice)
          .then((value) {
        if (value[0]) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Invoice saved")));
          setState(() {
            isLoad = false;
          });
          filePath = value[1];
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Invoice not saved")));
          Navigator.pop(context);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            onPressed: () {
              if (invoice.mobile != null && invoice.mobile!.isNotEmpty) {
                WhatsappShare.shareFile(
                    filePath: [filePath], phone: "91${invoice.mobile}");
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("No mobile number found"),
                  ),
                );
              }
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () async {
              await Printing.layoutPdf(
                  onLayout: (_) => generateInvoice(invoice));
            },
            icon: const Icon(Icons.print),
          ),
        ],
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PdfPreview(
              useActions: false,
              padding: const EdgeInsets.all(0),
              build: (format) => generateInvoice(invoice),
            ),
    );
  }
}

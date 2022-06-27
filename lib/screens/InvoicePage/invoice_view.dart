import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/utils/save_file.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

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
  late InvoiceResultModel invoice;

  @override
  void initState() {
    Provider.of<InvoiceChangeNotifier>(context, listen: false)
        .getInvoiceById(widget.invoiceId)
        .then((value) {
      invoice = value;
      SaveFile.saveFile(context, "${invoice.id}_${invoice.name}", invoice)
          .then((value) {
        if (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Invoice saved")));
          setState(() {
            isLoad = false;
          });
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
            onPressed: () {},
            icon: const Icon(Icons.whatsapp),
          ),
        ],
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : PdfPreview(
              allowPrinting: false,
              allowSharing: false,
              canChangeOrientation: false,
              canChangePageFormat: false,
              padding: const EdgeInsets.all(0),
              build: (format) => generateInvoice(invoice),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gen_invo/Models/invoice_change_notifier.dart';
import 'package:gen_invo/utils/save_file.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../Models/company_model.dart';
import '../../Models/invoice_result_model.dart';
import '../../service/database_service.dart';
import '../../utils/invoice_generator.dart';

class InvoiceView extends StatefulWidget {
  final int invoiceId;
  final bool isFromInvoicePage;
  const InvoiceView(
      {Key? key, required this.invoiceId, this.isFromInvoicePage = true})
      : super(key: key);

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  bool isLoad = true;
  String filePath = "";
  late InvoiceResultModel invoice;

  @override
  void initState() {
    if (widget.isFromInvoicePage) {
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
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invoice not saved")));
            Navigator.pop(context);
          }
        });
      });
    } else {
      Provider.of<InvoiceChangeNotifier>(context, listen: false)
          .getLastYearInvoiceById(widget.invoiceId)
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
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invoice not saved")));
            Navigator.pop(context);
          }
        });
      });
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (invoice.mobile != null && invoice.mobile!.isNotEmpty) {
            final res = await DatabaseService.instance.getCompanyDetails();
            CompanyModel companyData = res[0];
            launchUrlString(
              "https://wa.me/91${invoice.mobile}?text=Thanks for shopping with us\n${invoice.name}\nRegards from\n${companyData.name}",
              mode: LaunchMode.externalApplication,
            );
            // WhatsappShare.share(
            //     phone: "91${invoice.mobile}",
            //     text:
            //         "Thanks for shopping with us\n${invoice.name}\nRegards from\n${companyData.name}");
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No mobile number found"),
              ),
            );
          }
        },
        child: const Icon(Icons.chat),
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

import 'dart:typed_data';

import 'package:gen_invo/Models/company_model.dart';
import 'package:gen_invo/MyExtension/my_extention.dart';
import 'package:gen_invo/service/database_service.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../Models/invoice_result_model.dart';

Future<Uint8List> generateInvoice(InvoiceResultModel invoiceData) async {
  // final lorem = pw.LoremText();
  final res = await DatabaseService.instance.getCompanyDetails();
  CompanyModel companyData = res[0];

  final products = <Product>[
    Product(
        '1',
        invoiceData.title!,
        invoiceData.hsn.toString(),
        invoiceData.weightInGrams!.toString(),
        invoiceData.ratePerGram!.toString(),
        invoiceData.totalCost!.toString()),
  ];

  final invoice = Invoice(
    invoiceNumber: invoiceData.id.toString(),
    products: products,
    customerName: invoiceData.name!,
    customerAddress: invoiceData.address!,
    customerGST: invoiceData.gst!.toString(),
  );

  return await invoice.buildPdf(invoiceData, companyData);
}

class Invoice {
  Invoice({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.customerGST,
  });

  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final String customerGST;

  static const _darkColor = PdfColors.blueGrey800;

  Future<Uint8List> buildPdf(
      InvoiceResultModel invoiceData, CompanyModel companyData) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(30),
        build: (context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColors.black,
                width: 1,
              ),
            ),
            child: pw.Column(
              children: [
                _buildHeader(context, invoiceData, companyData),
                _contentHeader(context, invoiceData),
                _contentTable(context),
                _contentFooter(context, invoiceData, companyData),
                _termsAndConditions(context, companyData),
              ],
            ),
          );
        },
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context, InvoiceResultModel invoiceData,
      CompanyModel companyData) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Column(
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                child: pw.Text(
                  '  GSTIN: ${companyData.gstNumber}',
                  style: pw.TextStyle(
                    color: PdfColors.red,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Spacer(),
              pw.Container(
                child: pw.Text(
                  'Phone: ${companyData.phoneNumber}  ',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.Text(
            "TAX INVOICE",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            "${companyData.name}",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 36,
              color: const PdfColor(.12, .29, .49),
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            "${companyData.address}",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(vertical: 5),
            child: pw.Table(
              border: const pw.TableBorder(
                top: pw.BorderSide(),
              ),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text(" Invoice\n No."),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text(invoiceData.id.toString()),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text("Invoice Date:"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text(_formatDate(invoiceData.date!)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text("Transporter\nName/Model:"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5),
                      child: pw.Text(""),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Text(" State"),
                    pw.Text("Uttar Pradesh"),
                    pw.Text("State Code:"),
                    pw.Text("${companyData.stateCode}"),
                    pw.Text("Vehicle number:"),
                    pw.Text(""),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(" Issued From"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(""),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(""),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(""),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text("Lr. No. & Date:"),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(""),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (context.pageNumber > 1) pw.SizedBox(height: 20)
        ],
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context, InvoiceResultModel invoiceData) {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: [
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(5),
                child: pw.Text(
                  "Details of Receiver/Bill To:",
                  textAlign: pw.TextAlign.center,
                  textScaleFactor: 1.2,
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfColors.black,
                    width: 1,
                  ),
                ),
                child: pw.Text(
                  "Details of Consignee/Shipped To:",
                  textAlign: pw.TextAlign.center,
                  textScaleFactor: 1.2,
                ),
              ),
            ),
          ],
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Table(
                columnWidths: {
                  0: const pw.FixedColumnWidth(6),
                  1: const pw.FixedColumnWidth(20),
                  2: const pw.FixedColumnWidth(6),
                  3: const pw.FixedColumnWidth(20),
                },
                border: const pw.TableBorder(
                  top: pw.BorderSide(width: 01),
                  verticalInside: pw.BorderSide(width: 01),
                ),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, left: 5, bottom: 5),
                        child: pw.Text(
                          "Name:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, left: 5, bottom: 5),
                        child: pw.Text(
                          customerName,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, left: 5, bottom: 5),
                        child: pw.Text(
                          "Name:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, left: 5, bottom: 5),
                        child: pw.Text(
                          "",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "address:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          customerAddress,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "address:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, left: 5, bottom: 5),
                        child: pw.Text(
                          "GSTIN:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          customerGST,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "GSTIN:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "State:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              invoiceData.state!,
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "State Code: 09",
                              textAlign: pw.TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "State:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              "",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "State Code: ",
                              textAlign: pw.TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 5),
                          child: pw.Text(
                            "Contact:",
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          invoiceData.mobile!,
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 5),
                          child: pw.Text(
                            "Contact:",
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 5),
                        child: pw.Text(
                          " ",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context, InvoiceResultModel invoiceData,
      CompanyModel companyData) {
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              child: pw.DefaultTextStyle(
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.black,
                ),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Total invoice Amount in words:",
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          NumberToWord()
                              .convert("en-in", invoiceData.netAmount!)
                              .toTitleCase(),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Our Bank Details:",
                        ),
                        pw.Text(
                          "${companyData.bankName} - ${companyData.bankAddress}",
                          // "Bank- Central Bank of India - Favvara Branch, Agra",
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          "Account No./IFSC- ${companyData.accountNumber} / ${companyData.ifscCode}",
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.RichText(
                          text: pw.TextSpan(
                            text: "Payment Received in Cash/Bank: ",
                            children: [
                              pw.TextSpan(
                                text: invoiceData.isCash == 1 &&
                                        invoiceData.isUPI == 1 &&
                                        invoiceData.isCheque == 1
                                    ? "By Cash, UPI and Cheque"
                                    : invoiceData.isCash == 1 &&
                                            invoiceData.isUPI == 1
                                        ? "By Cash and UPI"
                                        : invoiceData.isUPI == 1 &&
                                                invoiceData.isCheque == 1
                                            ? "By UPI and Cheque"
                                            : invoiceData.isCash == 1 &&
                                                    invoiceData.isCheque == 1
                                                ? "By Cash and Cheque"
                                                : invoiceData.isCash == 1
                                                    ? "By Cash"
                                                    : invoiceData.isUPI == 1
                                                        ? "By UPI"
                                                        : "By Cheque",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        if (invoiceData.isCheque == 1)
                          pw.RichText(
                            text: pw.TextSpan(
                              text: "Cheque Details: ",
                              children: [
                                pw.TextSpan(
                                  text:
                                      "${invoiceData.bankName}-${invoiceData.chequeNumber}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.DefaultTextStyle(
              style: const pw.TextStyle(
                fontSize: 10,
                color: _darkColor,
              ),
              child: pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Other Charges, if any",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Total Amount -before TAX",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.totalCost}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " CGST",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.cgst}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " SGST",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.sgst}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " IGST",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.igst}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Round Off / Discount",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${(invoiceData.totalAmountWithRounding! - invoiceData.totalAmountWithoutRounding!).toStringAsFixed(2)}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Total amount after tax (Rounded)",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.totalAmountWithRounding!}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Received (By Cash)",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.receivedInCash}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Received (By UPI)",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.receivedInUPI}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Received (By Cheque)",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${invoiceData.receivedInCheque}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          "Balance",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${(invoiceData.netAmount! - invoiceData.receivedInCash!)}",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _termsAndConditions(pw.Context context, CompanyModel companyData) {
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Text(
            "TERMS & CONDITIONS : 1. GOODS once Sold will not be returned. 2. Interest @24% shall be changed on all over due payments from the date of invoice. 3. Our responsibility ceases as soon as the goods are handled over to the carrier. 4. Payment to be made throught RTGS/NEFT only. 5. Subject to ${companyData.city} Jurisdiction only.",
            textAlign: pw.TextAlign.justify,
            style: const pw.TextStyle(
              fontSize: 10,
              lineSpacing: 2,
              color: _darkColor,
            ),
          ),
        ),
        pw.Table(
          border: const pw.TableBorder(
            left: pw.BorderSide(width: 01),
            right: pw.BorderSide(width: 01),
            bottom: pw.BorderSide(width: 01),
            verticalInside: pw.BorderSide(width: 01),
          ),
          children: [
            pw.TableRow(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    "Receiver's Signature",
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.all(5),
                  child: pw.Text(
                    "For Hiralal & Brothers",
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                pw.SizedBox(height: 50),
                pw.SizedBox(height: 50),
              ],
            ),
          ],
        )
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'SNO ',
      'DESCRIPTION OF GOODS',
      'HSN CODE',
      'weight(In GM)',
      'Rate(per GM)',
      'Taxable-Value',
    ];
    return pw.Expanded(
      child: pw.Column(
        children: [
          pw.Table.fromTextArray(
            border: const pw.TableBorder(
              left: pw.BorderSide(color: PdfColors.black),
              right: pw.BorderSide(color: PdfColors.black),
            ),
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            headerHeight: 25,
            cellHeight: 40,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
            },
            headerStyle: const pw.TextStyle(
              color: PdfColors.black,
              fontSize: 10,
            ),
            // cellStyle: const pw.TextStyle(
            //   color: _darkColor,
            //   fontSize: 10,
            // ),
            // rowDecoration: pw.BoxDecoration(
            // border: pw.Border(
            //   bottom: pw.BorderSide(
            //     color: accentColor,
            //     // width: .5,
            //   ),
            // ),
            // ),
            headers: List<String>.generate(
              tableHeaders.length,
              (col) => tableHeaders[col],
            ),
            // data: List<List<String>>.generate(1, (index) => List<String>.generate(
            //   tableHeaders.length,
            //   (col) => '',
            // )),
            data: List<List<String>>.generate(
              products.length,
              (row) => List<String>.generate(
                tableHeaders.length,
                (col) => products[row].getIndex(col),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  const Product(
    this.sno,
    this.productName,
    this.hsnCode,
    this.weight,
    this.rate,
    this.total,
  );

  final String sno;
  final String productName;
  final String hsnCode;
  final String weight;
  final String rate;
  final String total;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sno;
      case 1:
        return productName;
      case 2:
        return hsnCode.toString();
      case 3:
        return weight.toString();
      case 4:
        return rate.toString();
      case 5:
        return total;
    }
    return '';
  }
}

String _formatDate(String date) {
  var temp = DateTime.parse(
      "${date.split("-")[2]}-${date.split("-")[1]}-${date.split("-")[0]}");
  final format = DateFormat.yMMMd('en_US');
  return format.format(temp);
}

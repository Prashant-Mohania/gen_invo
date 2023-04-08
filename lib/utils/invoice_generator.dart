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
      invoiceData.weightInGrams!,
      invoiceData.ratePerGram! * 1000,
      invoiceData.totalCost!,
    ),
  ];

  final invoice = Invoice(
    invoiceNumber: invoiceData.id.toString(),
    products: products,
    customerName: invoiceData.name!,
    customerAddress:
        invoiceData.address!.isEmpty ? invoiceData.city! : invoiceData.address!,
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
                  '  GSTIN: ${companyData.gstNumber!.toUpperCase()}',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#bb1312'),
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
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                decoration: pw.TextDecoration.underline),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            "${companyData.name}",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 30,
              color: const PdfColor(.12, .29, .49),
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            "${companyData.address}, ${companyData.city}, ${companyData.state}",
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
                      child: pw.Text(" Invoice No."),
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
                    pw.Text(" State:"),
                    pw.Text("Uttar Pradesh"),
                    pw.Text("State Code:"),
                    pw.Text("09"),
                    pw.Text("Vehicle number:"),
                    pw.Text(""),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 5),
                      child: pw.Text(" Issued From:"),
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
                          textScaleFactor: .9,
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
                          "Address:",
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
                          "Address:",
                          textScaleFactor: .9,
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
                          "GSTIN:",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          customerGST.toUpperCase(),
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 5, bottom: 5),
                        child: pw.Text(
                          "GSTIN:",
                          textScaleFactor: .9,
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
                              "State Code: ${invoiceData.gst!.isNotEmpty ? invoiceData.gst!.substring(0, 2) : invoiceData.state == "Uttar Pradesh" ? "09" : ""}",
                              textScaleFactor: .8,
                              textAlign: pw.TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(
                            top: 5, left: 5, bottom: 5),
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
                              "",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "State Code: ",
                              textScaleFactor: .8,
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
              padding: const pw.EdgeInsets.all(10),
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
                          "Total Invoice Amount in words:",
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          "${NumberToWord().convert("en-in", invoiceData.netAmount!).toTitleCase()}only",
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
                                                        : invoiceData
                                                                    .isCheque ==
                                                                1
                                                            ? "By Cheque"
                                                            : invoiceData
                                                                        .isRTGS ==
                                                                    1
                                                                ? "By RTGS"
                                                                : "",
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
                        // pw.SizedBox(height: 20),
                        if (invoiceData.isRTGS == 1)
                          pw.RichText(
                            text: pw.TextSpan(
                              text: "RTGS Status:",
                              children: [
                                pw.TextSpan(
                                  text: invoiceData.rtgsState,
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
              ),
              child: pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(10),
                  1: const pw.FixedColumnWidth(5),
                },
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
                        " ${_currencyFormat(invoiceData.totalCost!)}  ",
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " CGST @ 1.5%",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${_currencyFormat(invoiceData.cgst!)}  ",
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " SGST @ 1.5%",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${_currencyFormat(invoiceData.sgst!)}  ",
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " IGST @ 3.0%",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        " ${_currencyFormat(invoiceData.igst!)}  ",
                        textAlign: pw.TextAlign.right,
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
                        " ${(invoiceData.totalAmountWithRounding! - invoiceData.totalAmountWithoutRounding!).toStringAsFixed(2)}  ",
                        textAlign: pw.TextAlign.right,
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
                        " ${_currencyFormat(invoiceData.totalAmountWithRounding!.toDouble())}  ",
                        textAlign: pw.TextAlign.right,
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
                        " ${_currencyFormat(invoiceData.receivedInCash!.toDouble())}  ",
                        textAlign: pw.TextAlign.right,
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
                        " ${_currencyFormat(invoiceData.receivedInUPI!.toDouble())}  ",
                        textAlign: pw.TextAlign.right,
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
                        " ${_currencyFormat(invoiceData.receivedInCheque!.toDouble())}  ",
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text(
                          " Balance",
                          textAlign: pw.TextAlign.left,
                        ),
                      ),
                      pw.Text(
                        "${_currencyFormat((invoiceData.netAmount! - invoiceData.receivedInCash!).toDouble())}  ",
                        textAlign: pw.TextAlign.right,
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
      'Weight(In GM)',
      'Rate(per KG)',
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
            columnWidths: {
              0: const pw.FixedColumnWidth(4.8),
              1: const pw.FixedColumnWidth(10),
              2: const pw.FixedColumnWidth(6),
              3: const pw.FixedColumnWidth(4.9),
              4: const pw.FixedColumnWidth(9),
              5: const pw.FixedColumnWidth(7),
            },
            headerCellDecoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
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
              fontSize: 9,
            ),
            headers: List<String>.generate(
              tableHeaders.length,
              (col) => tableHeaders[col],
            ),
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
  final double weight;
  final double rate;
  final double total;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sno;
      case 1:
        return productName;
      case 2:
        return hsnCode.toString();
      case 3:
        return weight.toStringAsFixed(0);
      case 4:
        return _currencyFormat(rate, decimalDigit: 0);
      case 5:
        return _currencyFormat(total);
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

String _currencyFormat(double value, {int decimalDigit = 2}) {
  final format = NumberFormat.currency(
    locale: "HI",
    symbol: "",
    decimalDigits: decimalDigit,
  );
  return format.format(value);
}

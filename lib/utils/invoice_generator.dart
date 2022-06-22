import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Models/invoice_result_model.dart';

Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat, InvoiceResultModel invoiceData) async {
  // final lorem = pw.LoremText();

  final products = <Product>[
    Product(
        '1',
        invoiceData.title!,
        invoiceData.hsn.toString(),
        invoiceData.weightInGrams!.toString(),
        invoiceData.ratePerGram!.toString(),
        invoiceData.totalCost!.toString()),
    const Product("", "", "", "", "", ""),
    const Product("", "", "", "", "", ""),
    const Product("", "", "", "", "", ""),
    const Product("", "", "", "", "", ""),
  ];

  final invoice = Invoice(
    invoiceNumber: invoiceData.id.toString(),
    products: products,
    customerName: invoiceData.name!,
    customerAddress: invoiceData.address!,
    paymentInfo:
        '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
    tax: .15,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat, invoiceData);
}

class Invoice {
  Invoice({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;

  Future<Uint8List> buildPdf(
      PdfPageFormat pageFormat, InvoiceResultModel invoiceData) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: (context) => _buildHeader(context, invoiceData),
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context, invoiceData),
          _contentTable(context),
          _contentFooter(context, invoiceData),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context, InvoiceResultModel invoiceData) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
      decoration: pw.BoxDecoration(border: pw.Border.all()),
      child: pw.Column(
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                child: pw.Text(
                  'GSTIN: 09AAAFH8944G1Z6',
                  style: pw.TextStyle(
                    color: PdfColors.red,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Spacer(),
              pw.Container(
                child: pw.Text(
                  'Phone: 6713141',
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
            "Hiralal & Brothers",
            style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 36,
                color: PdfColors.purple900),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            "28/66 Seo ka Bazar, Agra, Uttar Pradesh, India",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.Table(
            border: const pw.TableBorder(
              top: pw.BorderSide(),
              bottom: pw.BorderSide(),
            ),
            children: [
              pw.TableRow(
                children: [
                  pw.Text("Invoice\nNo."),
                  pw.Text(invoiceData.id.toString()),
                  pw.Text("Invoice Date:"),
                  pw.Text(invoiceData.date!.toString()),
                  pw.Text("Transporter\nName/Model:"),
                  pw.Text(""),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("State"),
                  pw.Text("Uttar Pradesh"),
                  pw.Text("State Code:"),
                  pw.Text("09"),
                  pw.Text("Vehicle number:"),
                  pw.Text(""),
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Text("Issued From"),
                  pw.Text(""),
                  pw.Text(""),
                  pw.Text(""),
                  pw.Text("Lr. No. & Date:"),
                  pw.Text(""),
                ],
              ),
            ],
          ),
          if (context.pageNumber > 1) pw.SizedBox(height: 20)
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context, invoiceData) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: [
                pw.TableRow(
                  children: [
                    pw.Text(
                      "Details of Receiver/Bill To:",
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      "Details of Consignee/Shipped To:",
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      child: pw.Table(
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text(
                                "Name:",
                                textAlign: pw.TextAlign.left,
                              ),
                              pw.Text(
                                customerName,
                                textAlign: pw.TextAlign.left,
                              ),
                            ],
                          ),
                          pw.TableRow(children: [
                            pw.Text(
                              "address:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              customerAddress,
                              textAlign: pw.TextAlign.left,
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                              "GSTIN:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "",
                              textAlign: pw.TextAlign.left,
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                              "State:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  invoiceData.state!,
                                  textAlign: pw.TextAlign.left,
                                ),
                                pw.Text(
                                  "State Code: ${09}",
                                  textAlign: pw.TextAlign.left,
                                ),
                              ],
                            )
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                              "Contact:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "",
                              textAlign: pw.TextAlign.left,
                            ),
                          ]),
                        ],
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                      child: pw.Table(
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Text(
                                "Name:",
                                textAlign: pw.TextAlign.left,
                              ),
                              pw.Text(
                                "",
                                textAlign: pw.TextAlign.left,
                              ),
                            ],
                          ),
                          pw.TableRow(children: [
                            pw.Text(
                              "address:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "",
                              textAlign: pw.TextAlign.left,
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                              "GSTIN:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Text(
                              "",
                              textAlign: pw.TextAlign.left,
                            ),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                              "State:",
                              textAlign: pw.TextAlign.left,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "",
                                  textAlign: pw.TextAlign.left,
                                ),
                                pw.Text(
                                  "State Code: ${09}",
                                  textAlign: pw.TextAlign.left,
                                ),
                              ],
                            )
                          ]),
                        ],
                      ),
                    )
                  ],
                ),
              ]),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context, InvoiceResultModel invoiceData) {
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
                      children: [
                        pw.Text(
                          "Total invoice Amount in words:",
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          "",
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Our Bank Details:",
                        ),
                        pw.Text(
                          "Bank- Central Bank of India - Favvara Branch, Agra",
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          "Account No.//IFSC- 1525687806 / CBIN00001525",
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.RichText(
                          text: pw.TextSpan(
                              text: "Payment Received in Cash/Cheque: ",
                              children: [
                                pw.TextSpan(
                                  text: "By Cheque",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                )
                              ]),
                        ),
                        pw.RichText(
                          text:
                              pw.TextSpan(text: "Cheque Details: ", children: [
                            pw.TextSpan(
                              text: "union bank-039904",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            )
                          ]),
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
                      pw.Text(
                        "other Charges, if any",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        "",
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "Total Amount -before TAX",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.totalCost.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "CGST",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.cgst.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "SGST",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.sgst.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "IGST",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.igst.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "Round Off / Discount",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        (invoiceData.totalAmountWIthRounding! -
                                invoiceData.totalAmountWIthoutRounding!)
                            .toStringAsFixed(2),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "Total amount after tax (Rounded)",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.totalAmountWIthRounding!.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "Received (By Cash)",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.receivedInCash.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "Received (By Bank)",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.receivedInBank.toString(),
                        textAlign: pw.TextAlign.left,
                      ),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      pw.Text(
                        "Balance",
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.Text(
                        invoiceData.netAmount.toString(),
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

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          child: pw.Text(
            "TERMS & CONDITIONS : ${pw.LoremText().paragraph(40)}",
            textAlign: pw.TextAlign.justify,
            style: const pw.TextStyle(
              fontSize: 10,
              lineSpacing: 2,
              color: _darkColor,
            ),
          ),
        ),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Text(
                  "Receiver's Signature",
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  "For Hiralal & Brothers",
                  textAlign: pw.TextAlign.center,
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
    return pw.Table.fromTextArray(
      border: const pw.TableBorder(
        left: pw.BorderSide(color: PdfColors.black),
        right: pw.BorderSide(color: PdfColors.black),
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration:
          pw.BoxDecoration(border: pw.Border.all(color: PdfColors.black)),
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
      headerStyle: pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
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
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
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

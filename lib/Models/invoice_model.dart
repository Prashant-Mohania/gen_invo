class InvoiceModel {
  int? id,
      pId,
      iId,
      isCash,
      receivedInCash,
      discount,
      isUPI,
      receivedInUPI,
      isCheque,
      receivedInCheque,
      isRTGS,
      netAmount,
      totalAmountWithRounding,
      netBalance,
      isAdjusted;
  double? weightInGrams,
      ratePerGram,
      totalCost,
      cgst,
      sgst,
      igst,
      totalAmountWithoutRounding;
  String? date, chequeNumber, bankName, rtgsState, eta;

  InvoiceModel({
    this.id,
    this.pId,
    this.iId,
    this.isCash,
    this.receivedInCash,
    this.discount,
    this.isUPI,
    this.receivedInUPI,
    this.isCheque,
    this.receivedInCheque,
    this.bankName,
    this.chequeNumber,
    this.isRTGS,
    this.rtgsState,
    this.netAmount,
    this.totalAmountWithRounding,
    this.weightInGrams,
    this.ratePerGram,
    this.totalCost,
    this.cgst,
    this.sgst,
    this.igst,
    this.totalAmountWithoutRounding,
    this.date,
    this.netBalance,
    this.isAdjusted = 0,
    this.eta = "",
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        pId: json["pId"],
        iId: json["iId"],
        isCash: json["isCash"],
        receivedInCash: json["receivedInCash"],
        discount: json["discount"],
        isUPI: json["isUPI"],
        receivedInUPI: json["receivedInUPI"],
        isCheque: json["isCheque"],
        receivedInCheque: json["receivedInCheque"],
        bankName: json["bankName"],
        isRTGS: json['isRTGS'],
        rtgsState: json['rtgsState'],
        netAmount: json["netAmount"],
        totalAmountWithRounding: json["totalAmountWithRounding"],
        weightInGrams: json["weightInGrams"],
        ratePerGram: json["ratePerGram"],
        totalCost: json["totalCost"],
        cgst: json["cgst"],
        sgst: json["sgst"],
        igst: json["igst"],
        totalAmountWithoutRounding: json["totalAmountWithoutRounding"],
        date: json["date"],
        netBalance: json["netBalance"],
        isAdjusted: json["isAdjusted"],
        eta: json["eta"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["pId"] = pId;
    data["iId"] = iId;
    data["isCash"] = isCash;
    data["receivedInCash"] = receivedInCash;
    data["discount"] = discount;
    data["isUPI"] = isUPI;
    data["receivedInUPI"] = receivedInUPI;
    data["isCheque"] = isCheque;
    data["receivedInCheque"] = receivedInCheque;
    data["bankName"] = bankName;
    data["chequeNumber"] = chequeNumber;
    data["isRTGS"] = isRTGS;
    data["rtgsState"] = rtgsState;
    data["netAmount"] = netAmount;
    data["totalAmountWithRounding"] = totalAmountWithRounding;
    data["weightInGrams"] = weightInGrams;
    data["ratePerGram"] = ratePerGram;
    data["totalCost"] = totalCost;
    data["cgst"] = cgst;
    data["sgst"] = sgst;
    data["igst"] = igst;
    data["totalAmountWithoutRounding"] = totalAmountWithoutRounding;
    data["date"] = date;
    data['netBalance'] = netAmount! - receivedInCash!;
    data['isAdjusted'] = isAdjusted;
    data['eta'] = eta;
    return data;
  }

  InvoiceModel copyWith({
    int? id,
    int? pId,
    int? iId,
    int? isCash,
    int? receivedInCash,
    int? discount,
    int? isUPI,
    int? receivedInUPI,
    int? isCheque,
    int? receivedInCheque,
    String? bankName,
    int? isRTGS,
    String? rtgsState,
    int? netAmount,
    int? totalAmountWithRounding,
    int? netBalance,
    int? isAdjusted,
    double? weightInGrams,
    double? ratePerGram,
    double? totalCost,
    double? cgst,
    double? sgst,
    double? igst,
    double? totalAmountWithoutRounding,
    String? date,
    String? chequeNumber,
    String? eta,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      pId: pId ?? this.pId,
      iId: iId ?? this.iId,
      isCash: isCash ?? this.isCash,
      receivedInCash: receivedInCash ?? this.receivedInCash,
      discount: discount ?? this.discount,
      isUPI: isUPI ?? this.isUPI,
      receivedInUPI: receivedInUPI ?? this.receivedInUPI,
      isCheque: isCheque ?? this.isCheque,
      receivedInCheque: receivedInCheque ?? this.receivedInCheque,
      bankName: bankName ?? this.bankName,
      chequeNumber: chequeNumber ?? this.chequeNumber,
      isRTGS: isRTGS ?? this.isRTGS,
      rtgsState: rtgsState ?? this.rtgsState,
      netAmount: netAmount ?? this.netAmount,
      totalAmountWithRounding:
          totalAmountWithRounding ?? this.totalAmountWithRounding,
      weightInGrams: weightInGrams ?? this.weightInGrams,
      ratePerGram: ratePerGram ?? this.ratePerGram,
      totalCost: totalCost ?? this.totalCost,
      cgst: cgst ?? this.cgst,
      sgst: sgst ?? this.sgst,
      igst: igst ?? this.igst,
      totalAmountWithoutRounding:
          totalAmountWithoutRounding ?? this.totalAmountWithoutRounding,
      date: date ?? this.date,
      netBalance: netBalance ?? this.netBalance,
      isAdjusted: isAdjusted ?? this.isAdjusted,
      eta: eta ?? this.eta,
    );
  }
}

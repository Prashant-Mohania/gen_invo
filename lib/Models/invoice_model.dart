class InvoiceModel {
  int? id,
      pId,
      iId,
      isCash,
      receivedInCash,
      discount,
      isBank,
      receivedInBank,
      netAmount,
      totalAmountWithRounding,
      netBalance;
  double? weightInGrams,
      ratePerGram,
      totalCost,
      cgst,
      sgst,
      igst,
      totalAmountWithoutRounding;
  String? date;

  InvoiceModel({
    this.id,
    this.pId,
    this.iId,
    this.isCash,
    this.receivedInCash,
    this.discount,
    this.isBank,
    this.receivedInBank,
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
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        id: json["id"],
        pId: json["pId"],
        iId: json["iId"],
        isCash: json["isCash"],
        receivedInCash: json["receivedInCash"],
        discount: json["discount"],
        isBank: json["isBank"],
        receivedInBank: json["receivedInBank"],
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
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["pId"] = pId;
    data["iId"] = iId;
    data["isCash"] = isCash;
    data["receivedInCash"] = receivedInCash;
    data["discount"] = discount;
    data["isBank"] = isBank;
    data["receivedInBank"] = receivedInBank;
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
    return data;
  }

  InvoiceModel copyWith({
    int? id,
    int? pId,
    int? iId,
    int? isCash,
    int? receivedInCash,
    int? discount,
    int? isBank,
    int? receivedInBank,
    int? netAmount,
    int? totalAmountWithRounding,
    int? netBalance,
    double? weightInGrams,
    double? ratePerGram,
    double? totalCost,
    double? cgst,
    double? sgst,
    double? igst,
    double? totalAmountWithoutRounding,
    String? date,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      pId: pId ?? this.pId,
      iId: iId ?? this.iId,
      isCash: isCash ?? this.isCash,
      receivedInCash: receivedInCash ?? this.receivedInCash,
      discount: discount ?? this.discount,
      isBank: isBank ?? this.isBank,
      receivedInBank: receivedInBank ?? this.receivedInBank,
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
    );
  }
}

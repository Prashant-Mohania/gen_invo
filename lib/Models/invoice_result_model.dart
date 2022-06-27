class InvoiceResultModel {
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
      netAmount,
      totalAmountWithRounding,
      netBalance,
      partyId,
      itemId,
      hsn,
      isDefault;
  double? weightInGrams,
      ratePerGram,
      totalCost,
      cgst,
      sgst,
      igst,
      totalAmountWithoutRounding;
  String? date,
      chequeNumber,
      bankName,
      name,
      mobile,
      city,
      state,
      gst,
      email,
      address,
      title;

  InvoiceResultModel({
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
    this.partyId,
    this.name,
    this.mobile,
    this.city,
    this.state,
    this.gst,
    this.email,
    this.address,
    this.itemId,
    this.title,
    this.hsn,
    this.isDefault,
  });

  factory InvoiceResultModel.fromJson(Map<String, dynamic> json) {
    return InvoiceResultModel(
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
      chequeNumber: json["chequeNumber"],
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
      partyId: json['partyId'],
      name: json['name'],
      mobile: json['mobile'],
      city: json['city'],
      state: json['state'],
      gst: json['gst'],
      email: json['email'],
      address: json['address'],
      itemId: json['itemId'],
      title: json['title'],
      hsn: json['hsn'],
      isDefault: json['isDefault'],
    );
  }

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
    data['partyId'] = partyId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['city'] = city;
    data['state'] = state;
    data['gst'] = gst;
    data['email'] = email;
    data['address'] = address;
    data['itemId'] = itemId;
    data['title'] = title;
    data['hsn'] = hsn;
    data['isDefault'] = isDefault ?? 0;
    return data;
  }
}

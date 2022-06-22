class InvoiceResultModel {
  int? id,
      pId,
      iId,
      isCash,
      receivedInCash,
      discount,
      isBank,
      receivedInBank,
      netAmount,
      totalAmountWIthRounding,
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
      totalAmountWIthoutRounding;
  String? date, name, mobile, city, state, gst, email, address, title;

  InvoiceResultModel({
    this.id,
    this.pId,
    this.iId,
    this.isCash,
    this.receivedInCash,
    this.discount,
    this.isBank,
    this.receivedInBank,
    this.netAmount,
    this.totalAmountWIthRounding,
    this.weightInGrams,
    this.ratePerGram,
    this.totalCost,
    this.cgst,
    this.sgst,
    this.igst,
    this.totalAmountWIthoutRounding,
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
      isBank: json["isBank"],
      receivedInBank: json["receivedInBank"],
      netAmount: json["netAmount"],
      totalAmountWIthRounding: json["totalAmountWIthRounding"],
      weightInGrams: json["weightInGrams"],
      ratePerGram: json["ratePerGram"],
      totalCost: json["totalCost"],
      cgst: json["cgst"],
      sgst: json["sgst"],
      igst: json["igst"],
      totalAmountWIthoutRounding: json["totalAmountWIthoutRounding"],
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
    data["isBank"] = isBank;
    data["receivedInBank"] = receivedInBank;
    data["netAmount"] = netAmount;
    data["totalAmountWIthRounding"] = totalAmountWIthRounding;
    data["weightInGrams"] = weightInGrams;
    data["ratePerGram"] = ratePerGram;
    data["totalCost"] = totalCost;
    data["cgst"] = cgst;
    data["sgst"] = sgst;
    data["igst"] = igst;
    data["totalAmountWIthoutRounding"] = totalAmountWIthoutRounding;
    data["date"] = date;
    data['netBalance'] = receivedInBank!;
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

class CompanyModel {
  int? id, phoneNumber, stateCode, accountNumber;
  String? name,
      address,
      city,
      state,
      gstNumber,
      bankName,
      ifscCode,
      bankAddress;
  CompanyModel({
    this.id,
    this.name,
    this.address,
    this.city,
    this.state,
    this.stateCode,
    this.gstNumber,
    this.phoneNumber,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    this.bankAddress,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        stateCode: json["stateCode"],
        gstNumber: json["gstNumber"],
        phoneNumber: json["phoneNumber"],
        bankName: json["bankName"],
        accountNumber: json["accountNumber"],
        ifscCode: json["ifscCode"],
        bankAddress: json["bankAddress"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "state": state,
        "stateCode": stateCode,
        "gstNumber": gstNumber,
        "phoneNumber": phoneNumber,
        "bankName": bankName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "bankAddress": bankAddress,
      };

  copyWith({
    int? id,
    String? name,
    String? address,
    String? city,
    String? state,
    int? stateCode,
    String? gstNumber,
    int? phoneNumber,
    String? bankName,
    int? accountNumber,
    String? ifscCode,
    String? bankAddress,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      stateCode: stateCode ?? this.stateCode,
      gstNumber: gstNumber ?? this.gstNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      bankAddress: bankAddress ?? this.bankAddress,
    );
  }
}

class PartyModel {
  int? partyId;
  String? name, mobile, city, state, gst, email, address;

  PartyModel({
    this.partyId,
    this.name,
    this.mobile,
    this.city,
    this.state,
    this.gst,
    this.email,
    this.address,
  });

  PartyModel copyWith({
    int? partyId,
    String? name,
    String? mobile,
    String? city,
    String? state,
    String? gst,
    String? email,
    String? address,
  }) {
    return PartyModel(
      partyId: partyId ?? this.partyId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      city: city ?? this.city,
      state: state ?? this.state,
      gst: gst ?? this.gst,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['partyId'] = partyId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['city'] = city;
    data['state'] = state;
    data['gst'] = gst;
    data['email'] = email;
    data['address'] = address;
    return data;
  }

  factory PartyModel.fromJson(Map<String, dynamic> json) {
    return PartyModel(
      partyId: json['partyId'],
      name: json['name'],
      mobile: json['mobile'],
      city: json['city'],
      state: json['state'],
      gst: json['gst'],
      email: json['email'],
      address: json['address'],
    );
  }
}

import 'package:flutter/cupertino.dart';

class ItemModel extends ChangeNotifier {
  int? itemId;
  String? title;
  int? hsn;
  int? isDefault;
  int? isGold;

  ItemModel({
    this.itemId,
    this.title,
    this.hsn,
    this.isDefault,
    this.isGold,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    title = json['title'];
    hsn = json['hsn'];
    isDefault = json['isDefault'];
    isGold = json['isGold'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['title'] = title;
    data['hsn'] = hsn;
    data['isDefault'] = isDefault ?? 0;
    data['isGold'] = isGold ?? 0;
    return data;
  }

  ItemModel copyWith({
    int? itemId,
    String? title,
    int? hsn,
    int? isDefault,
    int? isGold,
  }) {
    return ItemModel(
      itemId: itemId ?? this.itemId,
      title: title ?? this.title,
      hsn: hsn ?? this.hsn,
      isDefault: isDefault ?? this.isDefault,
      isGold: isGold ?? this.isGold,
    );
  }
}

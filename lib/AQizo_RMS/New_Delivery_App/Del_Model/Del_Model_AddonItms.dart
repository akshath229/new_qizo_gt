
class Del_AddonItems {
  Del_AddonItems({
    required this.id,
    required this.mainItemId,
    required this.itemName,
    required this.maintItemUomId,
    required this.mainItemUom,
    required this.addOnitemId,
    required this.addonItemName,
    required this.addonItemUomId,
    required this.addonItemUom,
    required this.addonRate,
    required this.isActive,
    this.qty,
  });

  int id;
  int mainItemId;
  String itemName;
  int maintItemUomId;
  String mainItemUom;
  int addOnitemId;
  String addonItemName;
  int addonItemUomId;
  String addonItemUom;
  double addonRate;
  bool isActive;
  var qty;

  factory Del_AddonItems.fromJson(Map<String, dynamic> json) => Del_AddonItems(
    id: json["id"],
    mainItemId: json["mainItemId"],
    itemName: json["itemName"],
    maintItemUomId: json["maintItemUomId"],
    mainItemUom: json["mainItemUom"],
    addOnitemId: json["addOnitemId"],
    addonItemName: json["addonItemName"],
    addonItemUomId: json["addonItemUomId"],
    addonItemUom: json["addonItemUom"],
    addonRate: json["addonRate"],
    isActive: json["isActive"],
    //qty:1 ,
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mainItemId": mainItemId,
    "itemName": itemName,
    "maintItemUomId": maintItemUomId,
    "mainItemUOM": mainItemUom,
    "addOnitemId": addOnitemId,
    "addonItemName": addonItemName,
    "addonItemUomId": addonItemUomId,
    "addonItemUOM": addonItemUom,
    "addonRate": addonRate,
    "isActive": isActive,
    "qty": qty,
  };
}

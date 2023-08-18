class ProductType {
  ProductType({
    required this.id,
    required this.productType,
    required this.gtitemMaster,
    required this.mItemMaster,
  });

  int id;
  String productType;
  List<dynamic> gtitemMaster;
  List<dynamic> mItemMaster;

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
    id: json["id"],
    productType: json["productType"],
    gtitemMaster: List<dynamic>.from(json["gtitemMaster"].map((x) => x)),
    mItemMaster: List<dynamic>.from(json["mItemMaster"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productType": productType,
    "gtitemMaster": List<dynamic>.from(gtitemMaster.map((x) => x)),
    "mItemMaster": List<dynamic>.from(mItemMaster.map((x) => x)),
  };
}

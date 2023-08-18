class StockTypeStatics {
StockTypeStatics({
required this.id,
required this.stockType,
this.branchId,
this.displayCaption,
required this.gtitemMaster,
required this.mItemMaster,
});

int id;
String stockType;
dynamic branchId;
dynamic displayCaption;
List<dynamic> gtitemMaster;
List<dynamic> mItemMaster;

factory StockTypeStatics.fromJson(Map<String, dynamic> json) => StockTypeStatics(
id: json["id"],
stockType: json["stockType"],
branchId: json["branchId"],
displayCaption: json["displayCaption"],
gtitemMaster: List<dynamic>.from(json["gtitemMaster"].map((x) => x)),
mItemMaster: List<dynamic>.from(json["mItemMaster"].map((x) => x)),
);

Map<String, dynamic> toJson() => {
"id": id,
"stockType": stockType,
"branchId": branchId,
"displayCaption": displayCaption,
"gtitemMaster": List<dynamic>.from(gtitemMaster.map((x) => x)),
"mItemMaster": List<dynamic>.from(mItemMaster.map((x) => x)),
};
}

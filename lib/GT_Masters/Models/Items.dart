class ItemList {
  late int id;
  late String itmName;
  dynamic itmImage;
  late bool itmTaxInclusive;

  ItemList({required this.id, required this.itmName, this.itmImage, required this.itmTaxInclusive});

  ItemList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itmName = json['itmName'];
    itmImage = json['itmImage'];
    itmTaxInclusive = json['itmTaxInclusive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['itmName'] = this.itmName;
    data['itmImage'] = this.itmImage;
    data['itmTaxInclusive'] = this.itmTaxInclusive;

    return data;
  }
}



class ItmBillDetails {
  dynamic ItemSlNo;
  late int itemId;
  dynamic qty;
  dynamic rate;
  dynamic disPercentage;
  dynamic cgstPercentage;
  dynamic sgstPercentage;
  dynamic cessPercentage;
  dynamic discountAmount;
  dynamic cgstAmount;
  dynamic sgstAmount;
  dynamic cessAmount;
  dynamic igstPercentage;
  dynamic igstAmount;
  dynamic taxPercentage;
  dynamic taxAmount;
  dynamic taxInclusive;
  dynamic amountBeforeTax;
  dynamic amountIncludingTax;
  dynamic netTotal;
  dynamic hsncode;
  late int gdnId;
  late int taxId;
  late int rackId;
  late int addTaxId;
  late int unitId;
  late int nosInUnit;
  dynamic barcode;
  dynamic StockId;
  dynamic BatchNo;
  dynamic ExpiryDate;
  dynamic Notes;
  dynamic adlDiscAmount;
  dynamic adlDiscPercent;

  ItmBillDetails(
      {this.ItemSlNo,
        required this.itemId,
        this.qty,
        this.rate,
        this.disPercentage,
        this.cgstPercentage,
        this.sgstPercentage,
        this.cessPercentage,
        this.discountAmount,
        this.cgstAmount,
        this.sgstAmount,
        this.cessAmount,
        this.igstPercentage,
        this.igstAmount,
        this.taxPercentage,
        this.taxAmount,
        this.taxInclusive,
        this.amountBeforeTax,
        this.amountIncludingTax,
        this.netTotal,
        this.hsncode,
        required this.gdnId,
        required this.taxId,
        required this.rackId,
        required this.addTaxId,
        required this.unitId,
        required this.nosInUnit,
        this.barcode,
        this.StockId,
        this.BatchNo,
        this.ExpiryDate,
        this.Notes,
        this.adlDiscAmount,
        this.adlDiscPercent});

  ItmBillDetails.fromJson(Map<String, dynamic> json) {
    ItemSlNo = json['ItemSlNo'];
    itemId = json['itemId'];
    qty = json['qty'];
    rate = json['rate'];
    disPercentage = json['disPercentage'];
    cgstPercentage = json['cgstPercentage'];
    sgstPercentage = json['sgstPercentage'];
    cessPercentage = json['cessPercentage'];
    discountAmount = json['discountAmount'];
    cgstAmount = json['cgstAmount'];
    sgstAmount = json['sgstAmount'];
    cessAmount = json['cessAmount'];
    igstPercentage = json['igstPercentage'];
    igstAmount = json['igstAmount'];
    taxPercentage = json['taxPercentage'];
    taxAmount = json['taxAmount'];
    taxInclusive = json['taxInclusive'];
    amountBeforeTax = json['amountBeforeTax'];
    amountIncludingTax = json['amountIncludingTax'];
    netTotal = json['netTotal'];
    hsncode = json['hsncode'];
    gdnId = json['gdnId'];
    taxId = json['taxId'];
    rackId = json['rackId'];
    addTaxId = json['addTaxId'];
    unitId = json['unitId'];
    nosInUnit = json['nosInUnit'];
    barcode = json['barcode'];
    StockId = json['StockId'];
    BatchNo = json['BatchNo'];
    ExpiryDate = json['ExpiryDate'];
    Notes = json['Notes'];
    adlDiscAmount = json['adlDiscAmount'];
    adlDiscPercent = json['adlDiscPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemSlNo'] = this.ItemSlNo;
    data['itemId'] = this.itemId;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['disPercentage'] = this.disPercentage;
    data['cgstPercentage'] = this.cgstPercentage;
    data['sgstPercentage'] = this.sgstPercentage;
    data['cessPercentage'] = this.cessPercentage;
    data['discountAmount'] = this.discountAmount;
    data['cgstAmount'] = this.cgstAmount;
    data['sgstAmount'] = this.sgstAmount;
    data['cessAmount'] = this.cessAmount;
    data['igstPercentage'] = this.igstPercentage;
    data['igstAmount'] = this.igstAmount;
    data['taxPercentage'] = this.taxPercentage;
    data['taxAmount'] = this.taxAmount;
    data['taxInclusive'] = this.taxInclusive;
    data['amountBeforeTax'] = this.amountBeforeTax;
    data['amountIncludingTax'] = this.amountIncludingTax;
    data['netTotal'] = this.netTotal;
    data['hsncode'] = this.hsncode;
    data['gdnId'] = this.gdnId;
    data['taxId'] = this.taxId;
    data['rackId'] = this.rackId;
    data['addTaxId'] = this.addTaxId;
    data['unitId'] = this.unitId;
    data['nosInUnit'] = this.nosInUnit;
    data['barcode'] = this.barcode;
    data['StockId'] = this.StockId;
    data['BatchNo'] = this.BatchNo;
    data['ExpiryDate'] = this.ExpiryDate;
    data['Notes'] = this.Notes;
    data['adlDiscAmount'] = this.adlDiscAmount;
    data['adlDiscPercent'] = this.adlDiscPercent;
    return data;
  }
}



class StockType{

  late int id;
  dynamic stockType;
  // dynamic branchId;
  // dynamic displayCaption;
  // dynamic gtitemMaster;
  // dynamic mItemMaster;

  StockType({
    required this.id,
    this.stockType,
    // this.branchId,
    // this.displayCaption,
    // this.gtitemMaster,
    // this.mItemMaster
  });

  StockType.formJson(Map<String,dynamic>data) {
    id=data['id'];
    stockType=data['stockType'];
  }

}




class ProductType{

  late int id;
  dynamic productType;
  // dynamic branchId;
  // dynamic displayCaption;
  // dynamic gtitemMaster;
  // dynamic mItemMaster;

  ProductType({
    required this.id,
    this.productType,
    // this.branchId,
    // this.displayCaption,
    // this.gtitemMaster,
    // this.mItemMaster
  });

  ProductType.formJson(Map<String,dynamic>data) {
    id=data['id'];
    productType=data['productType'];
  }

}
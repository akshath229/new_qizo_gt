class Tax{

  late int txId;
  dynamic txDescription;
  late int txAddTaxId;
  dynamic atDescription;
  late int txTaxTypeId;
  dynamic txPercentage;
  dynamic txAccountHeadId;
  dynamic id;
  dynamic lhName;
  dynamic txCgstCaption;
  dynamic txCgstPercentage;
  dynamic txCgstTaxAccId;
  dynamic txCgstTaxAccLhName;
  dynamic txSgstCaption;
  dynamic txSgstPercentage;
  dynamic txSgstTaxAccId;
  dynamic txSgstTaxAccLhName;
  dynamic txIgstcaption;
  dynamic txIgstpercentage;
  dynamic  txIgstTaxAccId;
  dynamic txIgstTaxAccLhName;
  dynamic txPurchaseAccId;
  dynamic txPurchaseRtnAccId;
  dynamic txSaleseAccId;
  dynamic txSaleseRtnAccId;
  dynamic txIgstPurchaseAccId;
  dynamic  txIgstPurchaseRtnAccId;
  dynamic  txIgstSaleseAccId;
  dynamic txIgstSaleseRtnAccId;
  dynamic txSgstPurchaseAccId;
  dynamic txSgstPurchaseRtnAccId;
  dynamic txSgstSaleseAccId;
  dynamic txSgstSaleseRtnAccId;
  dynamic txCgstPurchaseAccId;
  dynamic  txCgstPurchaseRtnAccId;
  dynamic txCgstSaleseAccId;
  dynamic  txCgstSaleseRtnAccId;
  dynamic  txUserId;
  dynamic  txBranchId;

  Tax({
    required this.txId,
    this.txDescription,
    required this.txAddTaxId,
    this.atDescription,
    required this.txTaxTypeId,
    this.txPercentage,
    this.txAccountHeadId,
    this.id,
    this.lhName,
    this.txCgstCaption,
    this.txCgstPercentage,
    this.txCgstTaxAccId,
    this.txCgstTaxAccLhName,
    this.txSgstCaption,
    this.txSgstPercentage,
    this.txSgstTaxAccId,
    this.txSgstTaxAccLhName,
    this.txIgstcaption,
    this.txIgstpercentage,
    this.txIgstTaxAccId,
    this.txIgstTaxAccLhName,
    this.txPurchaseAccId,
    this.txPurchaseRtnAccId,
    this.txSaleseAccId,
    this.txSaleseRtnAccId,
    this.txIgstPurchaseAccId,
    this.txIgstPurchaseRtnAccId,
    this.txIgstSaleseAccId,
    this.txIgstSaleseRtnAccId,
    this.txSgstPurchaseAccId,
    this.txSgstPurchaseRtnAccId,
    this.txSgstSaleseAccId,
    this.txSgstSaleseRtnAccId,
    this.txCgstPurchaseAccId,
    this.txCgstPurchaseRtnAccId,
    this.txCgstSaleseAccId,
    this.txCgstSaleseRtnAccId,
    this.txUserId,
    this.txBranchId,
  });

  Tax.formJson(Map<String,dynamic>data) {
    txId=data['txId'];
    txDescription=data['txDescription'];
    txAddTaxId=data['txAddTaxId'];
    atDescription=data['atDescription'];
    txTaxTypeId=data['txTaxTypeId'];
    txPercentage=data['txPercentage'];
    txAccountHeadId=data['txAccountHeadId'];
    id=data['id'];
    lhName=data['lhName'];
    txCgstCaption=data['txCgstCaption'];
    txCgstPercentage=data['txCgstPercentage'];
    txCgstTaxAccId=data['txCgstTaxAccId'];
    txCgstTaxAccLhName=data['txCgstTaxAccLhName'];
    txSgstCaption=data['txSgstCaption'];
    txSgstPercentage=data['txSgstPercentage'];
    txSgstTaxAccId=data['txSgstTaxAccId'];
    txSgstTaxAccLhName=data['txSgstTaxAccLhName'];
    txIgstcaption=data['txIgstcaption'];
    txIgstpercentage=data['txIgstpercentage'];
    txIgstTaxAccId=data['txIgstTaxAccId'];
    txIgstTaxAccLhName=data['txIgstTaxAccLhName'];
    txPurchaseAccId=data['txPurchaseAccId'];
    txPurchaseRtnAccId=data['txPurchaseRtnAccId'];
    txSaleseAccId=data['txSaleseAccId'];
    txSaleseRtnAccId=data['txSaleseRtnAccId'];
    txIgstPurchaseAccId=data['txIgstPurchaseAccId'];
    txIgstPurchaseRtnAccId=data['txIgstPurchaseRtnAccId'];
    txIgstSaleseAccId=data['txIgstSaleseAccId'];
    txIgstSaleseRtnAccId=data['txIgstSaleseRtnAccId'];
    txSgstPurchaseAccId=data['txSgstPurchaseAccId'];
    txSgstPurchaseRtnAccId=data['txSgstPurchaseRtnAccId'];
    txSgstSaleseAccId=data['txSgstSaleseAccId'];
    txSgstSaleseRtnAccId=data['txSgstSaleseRtnAccId'];
    txCgstPurchaseAccId=data['txCgstPurchaseAccId'];
    txCgstPurchaseRtnAccId=data['txCgstPurchaseRtnAccId'];
    txCgstSaleseAccId=data['txCgstSaleseAccId'];
    txCgstSaleseRtnAccId=data['txCgstSaleseRtnAccId'];
    txUserId=data['txUserId'];
    txBranchId=data['txBranchId'];
  }



}
// {"id":137,"tvhCustId":69.0,"tvhLatitudeIn":"11.0713434",
// "tvhLongitudeIn":"75.9211014","tvhLocationIn":"  Malappuram",
// "tvhDateIn":"2020-09-08T18:05:04.377","tvhLatitudeOut":null,
// "tvhLongitudeOut":null,"tvhLocationOut":null,"tvhDateOut":null,
// "tvhUserId":6,"tvhDate":"2020-09-08T00:00:00"}

class ShopVisitsDate {
  int id;
  dynamic tvhCustId;
  dynamic tvhLatitudeIn;
  dynamic tvhLongitudeIn;
  dynamic tvhLocationIn;
  dynamic tvhDateIn;
  dynamic tvhLatitudeOut;
  dynamic tvhLongitudeOut;
  dynamic tvhLocationOut;
  dynamic tvhDateOut;
  dynamic tvhUserId;
  dynamic tvhDate;
  dynamic tvhRemarks;


  dynamic Customer;
  // dynamic Date;
  // dynamic TvhDateIn;
  // dynamic TvhDateOut;
  // dynamic  Remarks;


  ShopVisitsDate({
    required this.id,
    this.tvhCustId,
    this.tvhLatitudeIn,
    this.tvhLongitudeIn,
    this.tvhLocationIn,
    this.tvhDateIn,
    this.tvhLatitudeOut,
    this.tvhLongitudeOut,
    this.tvhLocationOut,
    this.tvhDateOut,
    this.tvhUserId,
    this.tvhDate,
    this.tvhRemarks,

    this.Customer,
    // this.Date,
    // this.TvhDateIn,
    // this.TvhDateOut,
    // this. Remarks,


  });

  factory ShopVisitsDate.fromJson(Map<String, dynamic> parsedJson) {
    return ShopVisitsDate(
      id: parsedJson["id"],
      tvhCustId: parsedJson["tvhCustId"],
      tvhLatitudeIn: parsedJson["tvhLatitudeIn"],
      tvhLongitudeIn: parsedJson["tvhLongitudeIn"],
      tvhLocationIn: parsedJson["tvhLocationIn"],
      tvhDateIn: parsedJson["tvhDateIn"],
      tvhLatitudeOut: parsedJson["tvhLatitudeOut"],
      tvhLongitudeOut: parsedJson["tvhLongitudeOut"],
      tvhLocationOut: parsedJson["tvhLocationOut"],
      tvhDateOut: parsedJson["tvhDateOut"],
      tvhUserId: parsedJson["tvhUserId"],
      tvhDate: parsedJson["tvhDate"],
      tvhRemarks: parsedJson["tvhRemarks"],
        Customer:parsedJson["Customer"],
        // Date: parsedJson["Date"],
        // TvhDateIn:parsedJson["TvhDateIn"],
        //  TvhDateOut:parsedJson["TvhDateOut"],
        // Remarks: parsedJson["Remarks"],
    );
  }
}

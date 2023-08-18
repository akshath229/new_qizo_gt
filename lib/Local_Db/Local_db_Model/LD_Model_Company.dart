 
class LD_Model_Company {
  LD_Model_Company({
    required this.companyProfileId,
    required this.companyProfileName,
    required this.companyProfileShortName,
    required this.companyProfileMailingName,
    required this.companyProfileAddress1,
    this.companyProfileAddress2,
    this.companyProfileAddress3,
    required this.companyProfileGstNo,
    this.companyProfilePan,
    required this.companyProfileMobile,
    required this.companyProfileContact,
    required this.companyProfileEmail,
    this.companyProfileWeb,
    required this.companyProfileBankName,
    required this.companyProfileAccountNo,
    required this.companyProfileBranch,
    required this.companyProfileIfsc,
    required this.companyProfileImagePath,
    this.companyProfileIsPrintHead,
    required this.companyProfileStateId,
    this.companyProfileLedgerId,
    this.companyProfilePin,
    this.companyProfileNameLatin,
    this.buildingNo,
    this.buildingNoLatin,
    this.streetName,
    this.streetNameLatin,
    this.district,
    this.districtLatin,
    this.city,
    this.cityLatin,
    this.country,
    this.countryLatin,
    this.pinNo,
    this.pinNoLatin,
    this.companyProfileLedger,
    this.companyProfileState,
  });

  int companyProfileId;
  String companyProfileName;
  String companyProfileShortName;
  String companyProfileMailingName;
  String companyProfileAddress1;
  dynamic companyProfileAddress2;
  dynamic companyProfileAddress3;
  String companyProfileGstNo;
  dynamic companyProfilePan;
  String companyProfileMobile;
  String companyProfileContact;
  String companyProfileEmail;
  dynamic companyProfileWeb;
  String companyProfileBankName;
  String companyProfileAccountNo;
  String companyProfileBranch;
  String companyProfileIfsc;
  String companyProfileImagePath;
  dynamic companyProfileIsPrintHead;
  int companyProfileStateId;
  dynamic companyProfileLedgerId;
  dynamic companyProfilePin;
  dynamic companyProfileNameLatin;
  dynamic buildingNo;
  dynamic buildingNoLatin;
  dynamic streetName;
  dynamic streetNameLatin;
  dynamic district;
  dynamic districtLatin;
  dynamic city;
  dynamic cityLatin;
  dynamic country;
  dynamic countryLatin;
  dynamic pinNo;
  dynamic pinNoLatin;
  dynamic companyProfileLedger;
  dynamic companyProfileState;

  factory LD_Model_Company.fromJson(Map<String, dynamic> json) => LD_Model_Company(
    companyProfileId: json["companyProfileId"],
    companyProfileName: json["companyProfileName"],
    companyProfileShortName: json["companyProfileShortName"],
    companyProfileMailingName: json["companyProfileMailingName"],
    companyProfileAddress1: json["companyProfileAddress1"],
    companyProfileAddress2: json["companyProfileAddress2"],
    companyProfileAddress3: json["companyProfileAddress3"],
    companyProfileGstNo: json["companyProfileGstNo"],
    companyProfilePan: json["companyProfilePan"],
    companyProfileMobile: json["companyProfileMobile"],
    companyProfileContact: json["companyProfileContact"],
    companyProfileEmail: json["companyProfileEmail"],
    companyProfileWeb: json["companyProfileWeb"],
    companyProfileBankName: json["companyProfileBankName"],
    companyProfileAccountNo: json["companyProfileAccountNo"],
    companyProfileBranch: json["companyProfileBranch"],
    companyProfileIfsc: json["companyProfileIfsc"],
    companyProfileImagePath: json["companyProfileImagePath"],
    companyProfileIsPrintHead: json["companyProfileIsPrintHead"],
    companyProfileStateId: json["companyProfileStateId"],
    companyProfileLedgerId: json["companyProfileLedgerId"],
    companyProfilePin: json["companyProfilePin"],
    companyProfileNameLatin: json["companyProfileNameLatin"],
    buildingNo: json["buildingNo"],
    buildingNoLatin: json["buildingNoLatin"],
    streetName: json["streetName"],
    streetNameLatin: json["streetNameLatin"],
    district: json["district"],
    districtLatin: json["districtLatin"],
    city: json["city"],
    cityLatin: json["cityLatin"],
    country: json["country"],
    countryLatin: json["countryLatin"],
    pinNo: json["pinNo"],
    pinNoLatin: json["pinNoLatin"],
    companyProfileLedger: json["companyProfileLedger"],
    companyProfileState: json["companyProfileState"],
  );

  Map<String, dynamic> toJson() => {
    "companyProfileId": companyProfileId,
    "companyProfileName": companyProfileName,
    "companyProfileShortName": companyProfileShortName,
    "companyProfileMailingName": companyProfileMailingName,
    "companyProfileAddress1": companyProfileAddress1,
    "companyProfileAddress2": companyProfileAddress2,
    "companyProfileAddress3": companyProfileAddress3,
    "companyProfileGstNo": companyProfileGstNo,
    "companyProfilePan": companyProfilePan,
    "companyProfileMobile": companyProfileMobile,
    "companyProfileContact": companyProfileContact,
    "companyProfileEmail": companyProfileEmail,
    "companyProfileWeb": companyProfileWeb,
    "companyProfileBankName": companyProfileBankName,
    "companyProfileAccountNo": companyProfileAccountNo,
    "companyProfileBranch": companyProfileBranch,
    "companyProfileIfsc": companyProfileIfsc,
    "companyProfileImagePath": companyProfileImagePath,
    "companyProfileIsPrintHead": companyProfileIsPrintHead,
    "companyProfileStateId": companyProfileStateId,
    "companyProfileLedgerId": companyProfileLedgerId,
    "companyProfilePin": companyProfilePin,
    "companyProfileNameLatin": companyProfileNameLatin,
    "buildingNo": buildingNo,
    "buildingNoLatin": buildingNoLatin,
    "streetName": streetName,
    "streetNameLatin": streetNameLatin,
    "district": district,
    "districtLatin": districtLatin,
    "city": city,
    "cityLatin": cityLatin,
    "country": country,
    "countryLatin": countryLatin,
    "pinNo": pinNo,
    "pinNoLatin": pinNoLatin,
    "companyProfileLedger": companyProfileLedger,
    "companyProfileState": companyProfileState,
  };




  Map<String, dynamic> toMap() => {
    "companyProfileId": companyProfileId,
    "companyProfileName": companyProfileName,
    "companyProfileShortName": companyProfileShortName,
    "companyProfileMailingName": companyProfileMailingName,
    "companyProfileAddress1": companyProfileAddress1,
    "companyProfileAddress2": companyProfileAddress2,
    "companyProfileAddress3": companyProfileAddress3,
    "companyProfileGstNo": companyProfileGstNo,
    "companyProfilePan": companyProfilePan,
    "companyProfileMobile": companyProfileMobile,
    "companyProfileContact": companyProfileContact,
    "companyProfileEmail": companyProfileEmail,
    "companyProfileWeb": companyProfileWeb,
    "companyProfileBankName": companyProfileBankName,
    "companyProfileAccountNo": companyProfileAccountNo,
    "companyProfileBranch": companyProfileBranch,
    "companyProfileIfsc": companyProfileIfsc,
    "companyProfileImagePath": companyProfileImagePath,
    "companyProfileIsPrintHead": companyProfileIsPrintHead,
    "companyProfileStateId": companyProfileStateId,
    "companyProfileLedgerId": companyProfileLedgerId,
    "companyProfilePin": companyProfilePin,
    "companyProfileNameLatin": companyProfileNameLatin,
    "buildingNo": buildingNo,
    "buildingNoLatin": buildingNoLatin,
    "streetName": streetName,
    "streetNameLatin": streetNameLatin,
    "district": district,
    "districtLatin": districtLatin,
    "city": city,
    "cityLatin": cityLatin,
    "country": country,
    "countryLatin": countryLatin,
    "pinNo": pinNo,
    "pinNoLatin": pinNoLatin,
    "companyProfileLedger": companyProfileLedger,
    "companyProfileState": companyProfileState,
  };
}

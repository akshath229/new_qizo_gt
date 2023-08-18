

class GetCompany {
  late int companyProfileId;
  late String companyProfileName;
  late String  companyProfileShortName;
  late String companyProfileMailingName;
  late String companyProfileAddress1;
  late String companyProfileAddress2;
  late String companyProfileAddress3;
  late String companyProfileGstNo;
  late String companyProfilePan;
  late String companyProfileMobile;
  late String companyProfileContact;
  late String companyProfileEmail;
  late String companyProfileWeb;
  late String companyProfileBankName;
  late String companyProfileAccountNo;
  late String companyProfileBranch;
  late String companyProfileIfsc;
  late String companyProfileImagePath;
  late String companyProfileIsPrintHead;
  late int companyProfileStateId;
  late int companyProfileLedgerId;

  GetCompany(
      {required this.companyProfileId,
        required this.companyProfileName,
        required this.companyProfileShortName,
        required this.companyProfileMailingName,
        required this.companyProfileAddress1,
        required this.companyProfileAddress2,
        required this.companyProfileAddress3,
        required this.companyProfileGstNo,
        required this.companyProfilePan,
        required this.companyProfileMobile,
        required this.companyProfileContact,
        required this.companyProfileEmail,
        required this.companyProfileWeb,
        required this.companyProfileBankName,
        required this.companyProfileAccountNo,
        required this.companyProfileBranch,
        required this.companyProfileIfsc,
        required this.companyProfileImagePath,
        required this.companyProfileIsPrintHead,
        required this.companyProfileStateId,
        required this.companyProfileLedgerId});

  GetCompany.fromJson(Map<String, dynamic> json) {
    companyProfileId = json['companyProfileId'];
    companyProfileName = json['companyProfileName'];
    companyProfileShortName = json['companyProfileShortName'];
    companyProfileMailingName = json['companyProfileMailingName'];
    companyProfileAddress1 = json['companyProfileAddress1'];
    companyProfileAddress2 = json['companyProfileAddress2'];
    companyProfileAddress3 = json['companyProfileAddress3'];
    companyProfileGstNo = json['companyProfileGstNo'];
    companyProfilePan = json['companyProfilePan'];
    companyProfileMobile = json['companyProfileMobile'];
    companyProfileContact = json['companyProfileContact'];
    companyProfileEmail = json['companyProfileEmail'];
    companyProfileWeb = json['companyProfileWeb'];
    companyProfileBankName = json['companyProfileBankName'];
    companyProfileAccountNo = json['companyProfileAccountNo'];
    companyProfileBranch = json['companyProfileBranch'];
    companyProfileIfsc = json['companyProfileIfsc'];
    companyProfileImagePath = json['companyProfileImagePath'];
    companyProfileIsPrintHead = json['companyProfileIsPrintHead'];
    companyProfileStateId = json['companyProfileStateId'];
    companyProfileLedgerId = json['companyProfileLedgerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyProfileId'] = this.companyProfileId;
    data['companyProfileName'] = this.companyProfileName;
    data['companyProfileShortName'] = this.companyProfileShortName;
    data['companyProfileMailingName'] = this.companyProfileMailingName;
    data['companyProfileAddress1'] = this.companyProfileAddress1;
    data['companyProfileAddress2'] = this.companyProfileAddress2;
    data['companyProfileAddress3'] = this.companyProfileAddress3;
    data['companyProfileGstNo'] = this.companyProfileGstNo;
    data['companyProfilePan'] = this.companyProfilePan;
    data['companyProfileMobile'] = this.companyProfileMobile;
    data['companyProfileContact'] = this.companyProfileContact;
    data['companyProfileEmail'] = this.companyProfileEmail;
    data['companyProfileWeb'] = this.companyProfileWeb;
    data['companyProfileBankName'] = this.companyProfileBankName;
    data['companyProfileAccountNo'] = this.companyProfileAccountNo;
    data['companyProfileBranch'] = this.companyProfileBranch;
    data['companyProfileIfsc'] = this.companyProfileIfsc;
    data['companyProfileImagePath'] = this.companyProfileImagePath;
    data['companyProfileIsPrintHead'] = this.companyProfileIsPrintHead;
    data['companyProfileStateId'] = this.companyProfileStateId;
    data['companyProfileLedgerId'] = this.companyProfileLedgerId;
    return data;
  }
}

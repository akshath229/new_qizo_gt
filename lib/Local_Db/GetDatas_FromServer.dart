import 'dart:convert';
import 'dart:developer';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/customersearch.dart';
import '../models/finishedgoods.dart';
import '../models/userdata.dart';
import '../sales.dart';
import '../urlEnvironment/urlEnvironment.dart';
import 'Local_db_Model/LD_Model_Company.dart';
import 'Local_db_Model/LD_Model_GeneralSettings.dart';


class GetData_FromServer{

  late UserData pref;
  static List<UnitTypes> units = <UnitTypes>[];
  static List<UnitType> unit = <UnitType>[];
  static List<Customer> Ledg_custmoer = [];
  static List<FinishedGoods> goods = [];
  static List<Godown> Gdwn = [];
  static List<LD_Model_Company> cmpny = [];
  static List<LD_Model_Generalset> GrlSet = [];

  GetPref()async{

    var  pref=await SharedPreferences.getInstance() ;

    var prefres = await pref.getString("userData");


    // print("prefres");
    // print(prefres);

    if (prefres != null) {
      var LoginPrefDatas=json.decode(prefres);

      var prefData=UserData.fromJson(LoginPrefDatas);
      return  prefData;
    }else{

      return null;
    }


  }


  late List <dynamic> Unit_tagsJsons;
  late List <dynamic> Unit_tagsJson;
  late List <dynamic> Godowm_tagsJson;
  late List <dynamic> Item_tagsJson;
  late List <dynamic> LedgerHead_tagsJson;
  late List <dynamic>Company_tagsJson;



  GetUnit_Servers()async{
    pref = await GetPref();
    print("the preferance is " + pref.toString());
    // print(pref.password);
    // print(pref.user["token"]);

    String url = "${Env.baseUrl}GtRelItemUoms";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
      // print("Units");
      // print(res.body);
      print("the preferance is " + res.body.toString());
      if(res.statusCode==200) {
        Unit_tagsJsons = json.decode(res.body);
        List<UnitTypes> ut = Unit_tagsJsons.map((tagsJson) =>
            UnitTypes.fromJson(tagsJson)).toList();
        units = ut;
        return units;
      }else{
        List<UnitTypes> ut = Unit_tagsJsons.map((tagsJson) =>
            UnitTypes.fromJson(tagsJson)).toList();
        units = ut;
        return units;
      }
    }catch(e){print("error on GetUnit_Server: $e");}
  }







  GetUnit_Server()async{
    pref = await GetPref();
    print("the preferance is " + pref.toString());
    // print(pref.password);
    // print(pref.user["token"]);

    String url = "${Env.baseUrl}GtUnits";
    try {
      final res =
          await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
      // print("Units");
      // print(res.body);
      if(res.statusCode==200) {
        Unit_tagsJson = json.decode(res.body);
        List<UnitType> ut = Unit_tagsJson.map((tagsJson) =>
        UnitType.fromJson(tagsJson)).toList();
       unit = ut;
       return unit;
      }else{
        List<UnitType> ut = Unit_tagsJson.map((tagsJson) =>
            UnitType.fromJson(tagsJson)).toList();
        unit = ut;
        return unit;
      }
    }catch(e){print("error on GetUnit_Server: $e");}
  }


  GetLedgerHeads_Server()async{
    pref = await GetPref();
    String url = "${Env.baseUrl}MLedgerHeads";
    try {
    final res =
    await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
    // print("Units");
    if(res.statusCode==200) {
      LedgerHead_tagsJson = json.decode(res.body)["ledgerHeads"];
      List<Customer> data = LedgerHead_tagsJson.map((tagsJson) =>
          Customer.fromJson(tagsJson)).toList();
      Ledg_custmoer = data;
      return Ledg_custmoer;
    }else{
      List<Customer> data = LedgerHead_tagsJson.map((tagsJson) =>
          Customer.fromJson(tagsJson)).toList();
      Ledg_custmoer = data;
      return Ledg_custmoer;
    }
    }catch(e){print("error on GetLedgerHeads_Server: $e");}
  }



  GetItemMaster_Server()async{
    pref = await GetPref();
    String url = "${Env.baseUrl}GtItemMasters/1/1";
    try {
    final res =
    await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
    // print("GtItemMasters/1/1");
   // print(res.body);
    if(res.statusCode==200) {
      Item_tagsJson = json.decode(res.body);
      List<FinishedGoods> data = Item_tagsJson.map((tagsJson) =>
          FinishedGoods.fromJson(tagsJson)).toList();
      goods = data;
      return goods;
    }else {
      List<FinishedGoods> data = Item_tagsJson.map((tagsJson) =>
          FinishedGoods.fromJson(tagsJson)).toList();
      goods = data;
      return goods;
    }
    }catch(e){print("error on GetItemMaster_Server: $e");}
  }




  Get_Godowm_Server()async{
    pref = await GetPref();
    String url = "${Env.baseUrl}Mgodowns";
      try {
    final res =
    await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
    // print("Godowm");
    // print(res.body);
    if(res.statusCode==200) {
        Godowm_tagsJson = json.decode(res.body)['mGodown'];
      List<Godown> data = Godowm_tagsJson.map((tagsJson) =>
          Godown.fromJson(tagsJson)).toList();
      Gdwn = data;
      return Gdwn;
    }else{
      List<Godown> data = Godowm_tagsJson.map((tagsJson) =>
          Godown.fromJson(tagsJson)).toList();
      Gdwn = data;
      return Gdwn;
    }
      }catch(e){print("error on Get_Godowm_Server: $e");}
  }



  Get_GeneralData_Server()async{
    pref = await GetPref();
    String url = "${Env.baseUrl}generalSettings";
    try {
      final res =
      await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
      // print("Company data");
      // print(res.body);
      if(res.statusCode==200) {
        print("the status code is " + res.statusCode.toString());
        Company_tagsJson = json.decode(res.body);

        print("the datasss ar " + Company_tagsJson.toString());


        List<LD_Model_Generalset> data = Company_tagsJson.map((tagsJson) =>
            LD_Model_Generalset.fromJson(tagsJson)).toList();
        GrlSet = data;
        return GrlSet;
      }else{
        List<LD_Model_Generalset> data = Company_tagsJson.map((tagsJson) =>
            LD_Model_Generalset.fromJson(tagsJson)).toList();
        GrlSet = data;
        return GrlSet;
      }
    }catch(e){print("error on Get_General_Server: $e");}
  }


  Get_CompanyData_Server()async{
    pref = await GetPref();
    String url = "${Env.baseUrl}MCompanyProfiles/1/${pref.BranchId}";
     try {
    final res =
    await http.get(url as Uri, headers: {"Authorization": pref.user["token"]});
    // print("Company data");
    // print(res.body);
    if(res.statusCode==200) {
      Company_tagsJson = json.decode(res.body)["mCompanyProfile"];
      List<LD_Model_Company> data = Company_tagsJson.map((tagsJson) =>
          LD_Model_Company.fromJson(tagsJson)).toList();
      cmpny = data;
      return cmpny;
    }else{
      List<LD_Model_Company> data = Company_tagsJson.map((tagsJson) =>
          LD_Model_Company.fromJson(tagsJson)).toList();
      cmpny = data;
      return cmpny;
    }
     }catch(e){print("error on Get_CompanyData_Server: $e");}
  }

}



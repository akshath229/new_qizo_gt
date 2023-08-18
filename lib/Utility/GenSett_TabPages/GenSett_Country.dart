// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_app/GT_Masters/AppTheam.dart';
// import 'package:flutter_app/GT_Masters/Masters_UI/cuWidgets.dart';
// import 'package:flutter_app/Utility/GenSett_TabPages/GenSett_Model/GennSett_InputBoxController.dart';
// import 'package:flutter_app/Utility/General_Setting.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// class GenSett_Country extends StatefulWidget {
//
//   TextEditingController country_code;
//   TextEditingController Country_Name;
//   TextEditingController Time_Zone_Code;
//   TextEditingController Currency_Name;
//   TextEditingController Currency_Decimals;
//   TextEditingController Currency_Coin_Name;
//   bool Enable_Makeorder_In_Rms;
//   bool Bypass_Delivery_Process_In_Rms;
//
//
//
//   GenSett_Country({
//     this.country_code,
//     this.Country_Name,
//     this.Currency_Coin_Name,
//     this.Currency_Decimals,
//     this.Currency_Name,
//     this.Time_Zone_Code,
//     this.Bypass_Delivery_Process_In_Rms,
//     this.Enable_Makeorder_In_Rms,
//   });
//
//   @override
//   _GenSett_CountryState createState() => _GenSett_CountryState();
// }
//
// class _GenSett_CountryState extends State<GenSett_Country> {
//
//   CUWidgets cw=CUWidgets();
//
// AppTheam theam= AppTheam();
//
//   var TimeZone=[
//
//     { "name":"Abu Dhabi,Arabian Standard Time"},
//     { "name":"Adelaide,Cen. Australia Standard Time"},
//     { "name":"Alaska,Alaskan Standard Time"},
//     { "name":"Almaty,Central Asia Standard Time"},
//     { "name":"American Samoa,UTC-11"},
//     { "name":"Amsterdam,W. Europe Standard Time"},
//     { "name":"Arizona,US Mountain Standard Time"},
//     { "name":"Astana,Bangladesh Standard Time"},
//     { "name":"Athens,GTB Standard Time"},
//     { "name":"Atlantic Time (Canada),Atlantic Standard Time"},
//     { "name":"Auckland,New Zealand Standard Time"},
//     { "name":"Azores,Azores Standard Time"},
//     { "name":"Baghdad,Arabic Standard Time"},
//     { "name":"Baku,Azerbaijan Standard Time"},
//     { "name":"Bangkok,SE Asia Standard Time"},
//     { "name":"Beijing,China Standard Time"},
//     { "name":"Belgrade,Central Europe Standard Time"},
//     { "name":"Berlin,W. Europe Standard Time"},
//     { "name":"Bern,W. Europe Standard Time"},
//     { "name":"Bogota,SA Pacific Standard Time"},
//     { "name":"Brasilia,E. South America Standard Time"},
//     { "name":"Bratislava,Central Europe Standard Time"},
//     { "name":"Brisbane,E. Australia Standard Time"},
//     { "name":"Brussels,Romance Standard Time"},
//     { "name":"Bucharest,GTB Standard Time"},
//     { "name":"Budapest,Central Europe Standard Time"},
//     { "name":"Buenos Aires,Argentina Standard Time"},
//     { "name":"Cairo,Egypt Standard Time"},
//     { "name":"Canberra,AUS Eastern Standard Time"},
//     { "name":"Cape Verde Is.,Cape Verde Standard Time"},
//     { "name":"Caracas,Venezuela Standard Time"},
//     { "name":"Casablanca,Morocco Standard Time"},
//     { "name":"Central America,Central America Standard Time"},
//     { "name":"Central Time (US & Canada),Central Standard Time"},
//     { "name":"Chennai,India Standard Time"},
//     { "name":"Chihuahua,Mountain Standard Time (Mexico)"},
//     { "name":"Chongqing,China Standard Time"},
//     { "name":"Copenhagen,Romance Standard Time"},
//     { "name":"Darwin,AUS Central Standard Time"},
//     { "name":"Dhaka,Bangladesh Standard Time"},
//     { "name":"Dublin,GMT Standard Time"},
//     { "name":"Eastern Time (US & Canada),Eastern Standard Time"},
//     { "name":"Edinburgh,GMT Standard Time"},
//     { "name":"Ekaterinburg,Ekaterinburg Standard Time"},
//     { "name":"Fiji,Fiji Standard Time"},
//     { "name":"Georgetown,SA Western Standard Time"},
//     { "name":"Greenland,Greenland Standard Time"},
//     { "name":"Guadalajara,Central Standard Time (Mexico)"},
//     { "name":"Guam,West Pacific Standard Time"},
//     { "name":"Hanoi,SE Asia Standard Time"},
//     { "name":"Harare,South Africa Standard Time"},
//     { "name":"Hawaii,Hawaiian Standard Time"},
//     { "name":"Helsinki,FLE Standard Time"},
//     { "name":"Hobart,Tasmania Standard Time"},
//     { "name":"Hong Kong,China Standard Time"},
//     { "name":"Indiana (East),US Eastern Standard Time"},
//     { "name":"International Date Line West,UTC-11"},
//     { "name":"Irkutsk,North Asia East Standard Time"},
//     { "name":"Islamabad,Pakistan Standard Time"},
//     { "name":"Istanbul,Turkey Standard Time"},
//     { "name":"Jakarta,SE Asia Standard Time"},
//     { "name":"Jerusalem,Israel Standard Time"},
//     { "name":"Kabul,Afghanistan Standard Time"},
//     { "name":"Kaliningrad,Kaliningrad Standard Time"},
//     { "name":"Kamchatka,Russia Time Zone 11"},
//     { "name":"Karachi,Pakistan Standard Time"},
//     { "name":"Kathmandu,Nepal Standard Time"},
//     { "name":"Kolkata,India Standard Time"},
//     { "name":"Krasnoyarsk,North Asia Standard Time"},
//     { "name":"Kuala Lumpur,Singapore Standard Time"},
//     { "name":"Kuwait,Arab Standard Time"},
//     { "name":"Kyiv,FLE Standard Time"},
//     { "name":"La Paz,SA Western Standard Time"},
//     { "name":"Lima,SA Pacific Standard Time"},
//     { "name":"Lisbon,GMT Standard Time"},
//     { "name":"Ljubljana,Central Europe Standard Time"},
//     { "name":"London,GMT Standard Time"},
//     { "name":"Madrid,Romance Standard Time"},
//     { "name":"Magadan,Magadan Standard Time"},
//     { "name":"Marshall Is.,UTC+12"},
//     { "name":"Mazatlan,Mountain Standard Time (Mexico)"},
//     { "name":"Melbourne,AUS Eastern Standard Time"},
//     { "name":"Mexico City,Central Standard Time (Mexico)"},
//     { "name":"Mid-Atlantic,UTC-02"},
//     { "name":"Midway Island,UTC-11"},
//     { "name":"Minsk,Belarus Standard Time"},
//     { "name":"Monrovia,Greenwich Standard Time"},
//     { "name":"Monterrey,Central Standard Time (Mexico)"},
//     { "name":"Montevideo,Montevideo Standard Time"},
//     { "name":"Moscow,Russian Standard Time"},
//     { "name":"Mountain Time (US & Canada),Mountain Standard Time"},
//     { "name":"Mumbai,India Standard Time"},
//     { "name":"Muscat,Arabian Standard Time"},
//     { "name":"Nairobi,E. Africa Standard Time"},
//     { "name":"New Caledonia,Central Pacific Standard Time"},
//     { "name":"New Delhi,India Standard Time"},
//     { "name":"Newfoundland,Newfoundland Standard Time"},
//     { "name":"Novosibirsk,N. Central Asia Standard Time"},
//     { "name":"Nuku'alofa,Tonga Standard Time"},
//     { "name":"Osaka,Tokyo Standard Time"},
//     { "name":"Pacific Time (US & Canada),Pacific Standard Time"},
//     { "name":"Paris,Romance Standard Time"},
//     { "name":"Perth,W. Australia Standard Time"},
//     { "name":"Port Moresby,West Pacific Standard Time"},
//     { "name":"Prague,Central Europe Standard Time"},
//     { "name":"Pretoria,South Africa Standard Time"},
//     { "name":"Quito,SA Pacific Standard Time"},
//     { "name":"Rangoon,Myanmar Standard Time"},
//     { "name":"Riga,FLE Standard Time"},
//     { "name":"Riyadh,Arab Standard Time"},
//     { "name":"Rome,W. Europe Standard Time"},
//     { "name":"Samara,Russia Time Zone 3"},
//     { "name":"Samoa,Samoa Standard Time"},
//     { "name":"Santiago,Pacific SA Standard Time"},
//     { "name":"Sapporo,Tokyo Standard Time"},
//     { "name":"Sarajevo,Central European Standard Time"},
//     { "name":"Saskatchewan,Canada Central Standard Time"},
//     { "name":"Seoul,Korea Standard Time"},
//     { "name":"Singapore,Singapore Standard Time"},
//     { "name":"Skopje,Central European Standard Time"},
//     { "name":"Sofia,FLE Standard Time"},
//     { "name":"Solomon Is.,Central Pacific Standard Time"},
//     { "name":"Srednekolymsk,Russia Time Zone 10"},
//     { "name":"Sri Jayawardenepura,Sri Lanka Standard Time"},
//     { "name":"St. Petersburg,Russian Standard Time"},
//     { "name":"Stockholm,W. Europe Standard Time"},
//     { "name":"Sydney,AUS Eastern Standard Time"},
//     { "name":"Taipei,Taipei Standard Time"},
//     { "name":"Tallinn,FLE Standard Time"},
//     { "name":"Tashkent,West Asia Standard Time"},
//     { "name":"Tbilisi,Georgian Standard Time"},
//     { "name":"Tehran,Iran Standard Time"},
//     { "name":"Tijuana,Pacific Standard Time"},
//     { "name":"Tokelau Is.,Tonga Standard Time"},
//     { "name":"Tokyo,Tokyo Standard Time"},
//     { "name":"Ulaanbaatar,Ulaanbaatar Standard Time"},
//     { "name":"Urumqi,Central Asia Standard Time"},
//     { "name":"UTC,UTC"},
//     { "name":"Vienna,W. Europe Standard Time"},
//     { "name":"Vilnius,FLE Standard Time"},
//     { "name":"Vladivostok,Vladivostok Standard Time"},
//     { "name":"Volgograd,Russian Standard Time"},
//     { "name":"Warsaw,Central European Standard Time"},
//     { "name":"Wellington,New Zealand Standard Time"},
//     { "name":"West Central Africa,W. Central Africa Standard Time"},
//     { "name":"Yakutsk,Yakutsk Standard Time"},
//     { "name":"Yerevan,Caucasus Standard Time"},
//     { "name":"Zagreb,Central European Standard Time"}
//
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(children: [
//
//
//         SizedBox(height: 10,),
//         cw.CUTestbox(
//             controllerName:widget.country_code,
//             label: "Country Code"
//
//         ),
//
//         SizedBox(height: 10,),
//
//         cw.CUTestbox(
//             controllerName: widget.Country_Name,
//             label: "Country Name"
//
//         ),
//
//
//         SizedBox(height: 10,),
//
//
//         Row(
//           children: [
//             Expanded(
//               child: TypeAheadField(
//                   textFieldConfiguration: TextFieldConfiguration(
//                     controller:widget.Time_Zone_Code ,
//                     style: TextStyle(),
//                     decoration: InputDecoration(
//                       errorStyle: TextStyle(color: Colors.red),
//                       isDense: true,
//                     //  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 5.0),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10)),
//
//                       hintStyle: TextStyle(color: Colors.black, fontSize: 15),
//                       labelText: "Time Zone Code",
//                     ),
//                   ),
//
//                   suggestionsBoxDecoration:
//                   SuggestionsBoxDecoration(elevation: 90.0),
//                   suggestionsCallback: (pattern) {
// //                        print(payment);
//                     return TimeZone.where((unt) => unt["name"].contains(pattern));
//                   },
//                   itemBuilder: (context, suggestion) {
//                     return Card(
//                       color: Colors.blue,
//                       child: ListTile(
//                         tileColor: theam.DropDownClr,
//                         title: Text(
//                           suggestion["name"],
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     );
//                   },
//                   onSuggestionSelected: (suggestion) {
//                     print(suggestion["name"]);
//                     print("Unit selected");
//                     widget.Time_Zone_Code.text = suggestion["name"];
//
//                   },
//                   errorBuilder: (BuildContext context, Object error) =>
//                       Text('$error',
//                           style: TextStyle(
//                               color: Theme.of(context).errorColor)),
//                   transitionBuilder:
//                       (context, suggestionsBox, animationController) =>
//                       FadeTransition(
//                         child: suggestionsBox,
//                         opacity: CurvedAnimation(
//                             parent: animationController,
//                             curve: Curves.elasticIn),
//                       )),
//             ),
//           ],
//         ),
//
//
//         SizedBox(height: 10,),
//
//         cw.CUTestbox(
//             controllerName: widget.Currency_Name,
//             label: "Currency Name"
//
//         ),
//
//
//
//
//        SizedBox(height: 10,),
//
//         cw.CUTestbox(
//             controllerName: widget.Currency_Decimals,
//             label: "Currency Decimals",
//             TextInputFormatter:  <TextInputFormatter>[
//               WhitelistingTextInputFormatter(RegExp(r"^\d+\.?\d{0,2}")),
//             ],
//              TextInputType: TextInputType.number,
//         ),
//
//
//         SizedBox(height: 10,),
//
//         cw.CUTestbox(
//             controllerName: widget.Currency_Coin_Name,
//             label: "Currency Coin Name"
//
//         ),
//
//
//
//       ],),
//     );
//   }
// }

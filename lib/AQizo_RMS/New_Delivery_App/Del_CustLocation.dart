import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';


class Del_Cust_Location extends StatefulWidget {
  @override
  _Del_Cust_LocationState createState() => _Del_Cust_LocationState();
}

class _Del_Cust_LocationState extends State<Del_Cust_Location> {

var Lan=0.0;
var Lon=0.0;

    MapnavigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng");
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  ///-----------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: Container(

      child: Column(
        children: [

          IconButton(icon: Icon(Icons.location_on), onPressed: () async {

            List<Placemark> placemark = await Geolocator().placemarkFromAddress("vellimadukunnu,calicut");
            print(placemark.toString());
            placemark.forEach((element) {

              print(element.administrativeArea.toString());
              print(element.country.toString());
              print(element.isoCountryCode.toString());
              print(element.locality.toString());
              print(element.name.toString());
              print(element.postalCode.toString());
              print(element.position.toString());
                  Lan=element.position.latitude;
                  Lon=element.position.longitude;
            });


          }),

          IconButton(icon: Icon(Icons.location_on), onPressed: () async {

            List<Placemark> placemark = await Geolocator().placemarkFromAddress("vellimadukunnu,calicut");
            placemark.forEach((element) {

              print(element.administrativeArea.toString());
              print(element.country.toString());
              print(element.isoCountryCode.toString());
              print(element.locality.toString());
              print(element.name.toString());
              print(element.postalCode.toString());
              print(element.position.toString());
    print(element.position.toString());
    Lan=element.position.latitude;
    Lon=element.position.longitude;
            });

            MapnavigateTo(Lan,Lon);

          }),







        ],
      ),

    )));
  }
}







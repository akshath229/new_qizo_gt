import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class SalesManMessages extends StatefulWidget {
  @override
  _SalesManMessagesState createState() => _SalesManMessagesState();
}

class _SalesManMessagesState extends State<SalesManMessages> {
//  String _token;
  TextEditingController msgController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getTok();
  }

//  getTok() {
//    firebaseMessaging.getToken().then((token) => _token = token);
//  }

  // Replace with server token from firebase console settings.
  final String serverToken = 'AAAARMr5030:APA91bGAz382eHp8HH7aShZAQ5XkQfas1zq1d97mgoSds4hzJ_2RmnRjv_VZeGELwHROQKGFqS6ng9uFx4nPNd2d4dwe-qWgnZqNHlaTHX5ew5mfWPeX_lYUWi_AHd5wZJTJ14NEX4E6';
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String toTopic = "/topics/"+'android';
  TextEditingController _controllerMessage =new TextEditingController();
  TextEditingController _controllerTitle = new TextEditingController();
  Future<void> sendAndRetrieveMessage() async {
    // await firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //       sound: true, badge: true, alert: true, provisional: false),
    // );

    String msg = _controllerMessage.text;
    String title= _controllerTitle.text;
    print("msg  : " +msg);
    print("title : "+title);

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': '${msg.toString()}',
            'title': '${title.toString()}'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // 'to':'$_token',
          'to':"$toTopic",
        },
      ),
    );

    _controllerTitle.text = "";
    _controllerMessage.text = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,
          title: Center(child: Text("Message"),)),
      body:
      ListView(
        children: <Widget>[


          ListTile(
            leading: Icon(Icons.send),
            title: TextField(
              controller: _controllerTitle,
              decoration: InputDecoration(labelText: "Message Subject"),
              keyboardType: TextInputType.text,
              onChanged: (String value) => setState(() {}),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.message),
            title: TextField(
              decoration: InputDecoration(labelText: " Add Message Topic"),
              controller: _controllerMessage,
              onChanged: (String value) => setState(() {}),
            ),
          ),
          Divider(),
//          ListTile(
//            title: Text("Can send SMS"),
////            subtitle: Text(_canSendSMSMessage),
//            trailing: IconButton(
//              padding: EdgeInsets.symmetric(vertical: 16),
//              icon: Icon(Icons.check),
//              onPressed: () {
//                sendAndRetrieveMessage();
//              },
//            ),
//          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary, // former accentColor
                padding: EdgeInsets.symmetric(vertical: 16),
                onPrimary: Theme.of(context).textTheme.button?.color, // adjust this if needed
              ),
              child: Text(
                "SEND",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                if (_controllerMessage.text == "" || _controllerTitle.text == "") {
                  return;
                } else {
                  sendAndRetrieveMessage();
                }
              },
            ),


          ),
//          Visibility(
//            visible: _message != null,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Expanded(
//                  child: Padding(
//                    padding: const EdgeInsets.all(12.0),
//                    child: Text(
//                      _message ?? "No Data",
//                      maxLines: null,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
        ],
      ),

    );
//      Row(
//        children: [
//
//          RaisedButton(
//            child: Text("send"),
//            onPressed: () {
//              sendAndRetrieveMessage();
//            },
//          )
//        ],
//      ),

  }
}

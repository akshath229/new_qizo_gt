import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//import 'package:flutter_razorpay_sdk/flutter_razorpay_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';

void main() => runApp(JobSheet());

class JobSheet extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<JobSheet> {
//  static const platform = const MethodChannel("razorpay_flutter");
  int totalAmount = 0;
  late Razorpay _razorpay;
  TextEditingController companyNameController = new TextEditingController();

  TextEditingController companyDescriptionController =
      new TextEditingController();

  @override
  void initState() {
    companyNameController.text = "";
    companyDescriptionController.text = "";
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_B1GHMMdZ96bUOS',
      'amount': totalAmount * 100,
//      'timeout': 60, // in seconds

      'name': companyNameController.text,
      'description': companyDescriptionController.text,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try {
      _razorpay.open(options);
      companyNameController.text = "";
      companyDescriptionController.text = "";
    } catch (e) {
      throw e;
    }
  }
//


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment success: ${response.paymentId}");

    Toast.show("Toast plugin app:${response.paymentId}", textStyle: context,
        duration: Toast.lengthShort, gravity: Toast.bottom);

//    Fluttertoast.showToast(
//        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);

//    Fluttertoast.showToast(
//        msg: "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error: ${response.message}");
    Toast.show(
        "Toast plugin app:${response.code}   .....${response.message}", textStyle: context,
        duration: Toast.lengthShort, gravity: Toast.bottom);
//    Fluttertoast.showToast(
//        msg: "ERROR: " + response.code.toString() + " - " + response.message,
//        timeInSecForIos: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet: ${response.walletName}");
    Toast.show("Toast plugin app:${response.walletName}", textStyle: context,
        duration: Toast.lengthShort, gravity: Toast.bottom);

//    Fluttertoast.showToast(
//        msg: "EXTERNAL_WALLET: " + response.walletName,timeInSecForIos: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Sample App'),
      ),
      body: Center(
          child: SizedBox(
            width: 320,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LimitedBox(
                maxWidth: 150.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Please enter some amount',
                  ),
                  onChanged: (value) {
                    setState(() {
                      totalAmount = num.parse(value).toInt();

                    });
                  },
                ),
              ),
              TextFormField(
                controller: companyNameController,

                enabled: true,
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  return null;
                },
//
                enableInteractiveSelection: false,
                // will disable paste operation
//                  focusNode: field1FocusNode,
                cursorColor: Colors.black,

                scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                keyboardType: TextInputType.text,

                decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0)),

                  // curve brackets object
//                    hintText: "Quantity",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                  labelText: "Company Name",
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                controller: companyDescriptionController,

                enabled: true,
                validator: (v) {
                  if (v!.isEmpty) return "Required";
                  return null;
                },
//
                enableInteractiveSelection: false,
                // will disable paste operation
//                  focusNode: field1FocusNode,
                cursorColor: Colors.black,

                scrollPadding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                keyboardType: TextInputType.text,

                decoration: InputDecoration(
//                    suffixIcon: Icon(
//                      Icons.calendar_today,
//                      color: Colors.blue,
//                      size: 24,
//                    ),
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0)),

                  // curve brackets object
//                    hintText: "Quantity",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 15),

                  labelText: "Description",
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // background color
                  onPrimary: Colors.white, // text color
                ),
                child: Text(
                  'Make Payment',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: openCheckout,
              )

            ]),
      )),
    );
  }
}

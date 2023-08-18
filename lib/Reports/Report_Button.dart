import 'package:flutter/material.dart';


class Report_Button{




  Padding ReportCustomButton({required BuildContext context, required String name, linkepage}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child:  GestureDetector(
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => linkepage),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 0.7),
              color:Colors.white,
              borderRadius: BorderRadius.circular(15)),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
              child:

              Center(
                child: Text(
                  name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ) ,
    );
  }



}
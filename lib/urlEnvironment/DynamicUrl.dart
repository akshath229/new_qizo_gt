import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:new_qizo_gt/urlEnvironment/urlEnvironment.dart';



enum BestTutorSite { Front, Back}
class DynamicUrlEdit extends StatefulWidget {

  @override
  _DynamicUrlEditState createState() => _DynamicUrlEditState();
}

class _DynamicUrlEditState extends State<DynamicUrlEdit> {
  BestTutorSite _site = BestTutorSite.Front;

  TextEditingController urlController = TextEditingController();
  // ignore: non_constant_identifier_names
  bool URL_Validator=false;
  @override
  Widget build(BuildContext context) {

    urlController.text = Env.baseUrl.toString();
    return SafeArea(
      child: Scaffold(
appBar:AppBar(
  backgroundColor: Colors.teal,
  centerTitle: true,
  automaticallyImplyLeading: false,
  title: Text(
    'Qizo GT',
  ),
),
        body: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'URL',
                    style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),


              SizedBox(height: 50,),

                      Row(
                        children: [
                         SizedBox(width: 70,) ,

                          Expanded(
                            child: TextFormField(
                              controller: urlController,
                              decoration:InputDecoration(
                                suffixIcon:
                                PopupMenuButton<int>(
                                    icon: Icon(Icons.info_outline,size: 35,),
                                    onSelected:(a){
                                      print("saf $a");
                                    } ,

                                    color:Colors.white,
                                    itemBuilder: (context) => [
                                      PopupMenuItem(height: 30,
                                          child:
                                          SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              height: 30,
                                              width: MediaQuery.of(context).size.width,
                                              child:  Text(Env.baseUrl.toString(),style: TextStyle(color: Colors.black),)

                                            ),
                                          )
                                      )
                                    ]),

                                // IconButton(icon: Icon(Icons.info_outline,size: 35,), onPressed: (){
                                //   print(Env.baseUrl.toString());
                                //
                                // }) ,
                                errorText: URL_Validator==true?"Please Enter Valid Url":null,
                                  hintText: "Enter URL",
                                contentPadding: EdgeInsets.all(8),
                              ) ,
                            ),
                          ),

                          SizedBox(width: 70,) ,


                        ],
                      ),


                      SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(top:0, left: 30),
                child: ListTile(
                  title: const Text('Front Camera'),
                  leading: Radio(
                    activeColor: Colors.teal,
                    value: BestTutorSite.Front,
                    groupValue: _site,
                    onChanged: (BestTutorSite? value) {
                      setState(() {
                        _site = value!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:0, left: 30),
                child: ListTile(
                  title: const Text('Back Camera'),
                  leading: Radio(
                    activeColor: Colors.teal,
                    value: BestTutorSite.Back,
                    groupValue: _site,
                    onChanged: (BestTutorSite? value) {
                      setState(() {
                        _site = value!;
                      });
                    },
                  ),
                ),
              ),

              Container(
                        width: 80,
                        color: Colors.teal,
                        child: TextButton(onPressed: (){
                          if(urlController.text.contains("http")){
                           setState(() {
                             print("sitess is " + _site.toString().substring(14));
                             URL_Validator=false;
                             Env.baseUrl=urlController.text;
                             Env.camera = _site.toString().substring(14);
                             Navigator.pop(context);
                           });


                          }else{
                            setState(() {
                              URL_Validator=true;
                            });
                          }


                        }, child: Text("OK",style: TextStyle(color: Colors.white),)),
                      )

            ],
          ),
        ),
      ),
    );
  }
}


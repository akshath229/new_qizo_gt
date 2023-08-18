import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class JobPending extends StatefulWidget {
  @override
  _JobPendingState createState() => _JobPendingState();
}

class _JobPendingState extends State<JobPending> {
  late File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Jobs"),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),

      ),


      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',

        child: Icon(Icons.add_a_photo),
      ),


    );
  }
}

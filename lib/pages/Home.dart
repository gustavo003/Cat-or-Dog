import 'dart:io';

import 'package:catordog/models/tflite_result.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:catordog/helpers/camera_helper.dart';
import 'package:catordog/helpers/tflite_helper.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
  }

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Gato ou cachorro?'),
        backgroundColor: Colors.orange,
      ),


      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildImage(),
            _buildResult(),
             Container(
               padding: EdgeInsets.only(bottom:20),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   FloatingActionButton(
                     heroTag: null,
                     child: Icon(Icons.photo_camera),
                     onPressed: _pickImage,
                   ),
                   SizedBox(width: 30,),
                   FloatingActionButton(
                     heroTag: null,
                     child: Icon(Icons.photo_album),
                     onPressed: _pickImage2,
                   ),
                 ],
               ),
             )

          ],
        ),
      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
        child: Container(
          padding: EdgeInsets.all(8.0),


          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black)
            ),
            child: Center(
              child: _image == null
                  ? Text('Sem imagen')
                  : Image.file(
                _image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pickImage2() async {
    final image = await CameraHelper.pickImage2();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }
  _pickImage() async {
    final image = await CameraHelper.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }


  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 50.0),
      child: Container(
        height: 150.0,

        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return Center(
        child: Text('Sem resultados'),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Text(
                // ignore: unrelated_type_equality_checks
                _outputs[index].label[0]==0?"Gato":"Cachorro" +' ( ${(_outputs[index].confidence * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              LinearPercentIndicator(
                lineHeight: 15,
                percent: _outputs[index].confidence,
              ),
            ],
          );
        },
      ),
    );
  }



}
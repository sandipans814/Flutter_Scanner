import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _result = "";
  String _type = "";
  double l,h,l1,h1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    l = MediaQuery.of(context).size.width / 2;
    l1 = MediaQuery.of(context).size.width / 2;
    h = MediaQuery.of(context).size.height / 2;
    h1 = MediaQuery.of(context).size.height / 5;
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter_Scanner'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: h1),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/scan.png',
                width: l1,
                height: h1,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                width: l,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color:Colors.lightBlue),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                  textColor: Colors.lightBlue,
                  splashColor: Colors.blueGrey,
                  padding: EdgeInsets.all(8.0),
                  onPressed: (){
                    scan();
                  },
                  child: Text("Scan Code",style: TextStyle(
                    fontSize: 18.0,
                  ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scan() async{
    try{
      ScanResult temp = await BarcodeScanner.scan();
      setState(() {
        _result = temp.rawContent;
        if(_result.contains('a'))
          _type  ='QRCode';
        else
          _type = temp.type.toString();
      });
    }
    on PlatformException catch(e){
      if(e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          _result = "Camera Access Denied";
        });
      }
      else{
        setState(() {
          _result = "Unknown Error: $e";
        });
      }
    }
    on FormatException catch(e){
      setState(() {
        _result = "User pressed back button before processing";
      });
    }
    catch(e){
      setState(() {
        _result = "Unknown Error: $e";
      });
    }
    showMessage(context);
  }
  void showMessage(BuildContext context) {

    AlertDialog alert = AlertDialog(
      title: Text("Your Scan result is : "),
      content: Text(_type + ":" + _result),
      actions: [
        FlatButton(
          child: Text("Ok"),
              onPressed:  () {
          Navigator.pop(context);
          },
        ),
    ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}



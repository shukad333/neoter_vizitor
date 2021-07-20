import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';

class Scanner extends StatefulWidget {




  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {


  String name = '';
  String number = '';


  @override
  void initState() {
    super.initState();
    print('Scanning!');
    // _scan();
    _scan();
  }


  Future _scanPhoto() async {
    await Permission.storage.request();
    String barcode = await scanner.scanPhoto();
    print(barcode);
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      List<String> sp = barcode.split("#");
      setState(() {
        name = sp[0];
        number = sp[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('Scanned'),),
      body: Column(

        children: [
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Row(
            children: [
              Text(name,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              new Divider(color: Colors.black12,),

            ],
          ),
          Divider(color: Colors.red,thickness: 1.0,),
          Row(
            children: [

              Text(number,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)
            ],
          )
        ],

      ),
    );
  }
}

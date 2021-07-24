import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_test/constants.dart';
import 'package:qr_test/model/visitor.dart';
import 'package:qr_test/visitor_db.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String name = '';
  String number = '';
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool iosQr = false;

  @override
  void initState() {
    super.initState();
    print('Scanning!');
    // _scan();
    // _scan();
  }

  @override
  void resassemble() {
    super.reassemble();
    controller!.resumeCamera();

  }

  Future _scanPhoto() async {
    await Permission.storage.request();
    String barcode = await scanner.scanPhoto();
    print(barcode);
  }

  Future _scan() async {
    if (Platform.isAndroid) {
      await Permission.camera.request();
      String? barcode = await scanner.scan();
      if (barcode == null) {
        print('nothing return.');
      } else {
        List<String> sp = barcode.split("#");
        setState(() {
          name = sp[0];
          number = sp[1];
          saveVisitor();
        });
      }
    }
    else if(Platform.isIOS) {
      // controller!.resumeCamera();
      setState(() {
        iosQr = true;
      });

    }
  }

  void _onQRViewCreated(QRViewController controller) {
    Barcode result;
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        print("Got! ${result.format} ${result.code}");
        List<String> sp = result.code.split("#");
          name = sp[0];
          number = sp[1];
          saveVisitor();
        this.iosQr = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scanner'),
        ),
        body: input());
  }

  void saveVisitor() {
    Visitor visitor = Visitor(name: name, number: number, time: DateTime.now());
    VisitorDb.instance.create(visitor);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Added $name')));
  }

  void setName(name) {
    setState(() {
      this.name = name;
    });
  }

  void setNumber(number) {
    setState(() {
      this.number = number;
    });
  }

  void scanAndUpdate() {
    _scan();
    // saveVisitor();
  }

  Widget iosScan() {
    return Column(
      children: [
        Expanded(
          flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated)
        )

      ],
    );
  }

  Widget input() {

    return iosQr? iosScan():
     Column(
      children: [
        Padding(padding: EdgeInsets.all(2)),
        Align(
          child:Text('Enter  for visitors without this app',style: TextStyle(fontSize: 22,fontStyle: FontStyle.italic),),alignment: Alignment.topLeft,),

        TextFormField(
          maxLines: 1,
          style: TextStyle(color: PRIMARY_TEXT_COLOR),
          decoration: InputDecoration(
              labelText: "Name",
              border: InputBorder.none,
              hintStyle: TextStyle(color: PRIMARY_TEXT_COLOR)),
          onChanged: (val) => setName(val),
        ),
        TextFormField(
          maxLines: 1,
          style: TextStyle(color: PRIMARY_TEXT_COLOR),
          decoration: InputDecoration(
              labelText: "Number",
              border: InputBorder.none,
              hintStyle: TextStyle(color: PRIMARY_TEXT_COLOR)),
          onChanged: (val) => setNumber(val),
        ),
        ElevatedButton(onPressed: saveVisitor, child: Text("Save")),
        const Divider(
          height: 20,
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Align(
          child:Text('Scan another Vizitor app',style: TextStyle(fontSize: 22,fontStyle: FontStyle.italic),),alignment: Alignment.topLeft,),

        SizedBox(height: 50,),

        ElevatedButton(onPressed: scanAndUpdate, child: Text('Scan QR')),
      ],
    );
  }

  Widget output() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Row(
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            new Divider(
              color: Colors.black12,
            ),
          ],
        ),
        Divider(
          color: Colors.red,
          thickness: 1.0,
        ),
        Row(
          children: [
            Text(
              number,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}

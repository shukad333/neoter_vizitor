import 'package:flutter/material.dart';
import 'package:qr_test/constants.dart';
import 'package:qr_test/model/visitor.dart';
import 'package:qr_test/visitor_db.dart';
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
    // _scan();
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
        saveVisitor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Scanned'),
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

  Widget input() {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(2)),
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
        Padding(padding: EdgeInsets.only(top: 200)),
        ElevatedButton(onPressed: scanAndUpdate, child: Text('Scan QR'))
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

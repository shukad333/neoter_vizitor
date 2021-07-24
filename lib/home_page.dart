import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String name = '';
  String number = '';
  bool loaded = false;

  @override
  void initState() {
    init();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  void init()  async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String nam = pref.getString('name') ?? '';
    String numb = pref.getString('number') ?? '';
    setState(() {
      name = nam;
      number = numb;
      loaded = true;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: loaded?name.isEmpty?emptyAdd():Column(
          // mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

             const SizedBox(height: 20),
            ClipOval(child: Image.asset('images/scan.jpeg',height: 200,width: 200,)),
            const SizedBox(height: 20),
            QrImage(
              data: "$name#$number",
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            Text("Scan your QR from another device",style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic),),

          ],
        ):CircularProgressIndicator()
      ),
    );
  }

  Widget emptyAdd() {
    return Center(
      child:
        Text(
          'Please Add details in Profile Page to generate your QR',
          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
        ),

    );
  }
}

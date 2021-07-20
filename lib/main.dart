import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_test/home_page.dart';
import 'package:qr_test/profile.dart';
import 'package:qr_test/scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,

      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Vizitor';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int selectedIndex = 1;

  List<StatefulWidget> _pages = [HomePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {

    final _pages = <Widget>[HomePage(), ProfilePage(),Scanner()];

    void setPage(index) {
      print("Setting index $index");
      setState(() {
        selectedIndex = index;
        print('Done .. $selectedIndex');
      });
    }

    return Scaffold(

      // body: IndexedStack(
      //   index: selectedIndex,
      //   children: [HomePage(), ProfilePage()],
      // ),

      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.camera),label: 'Scan')
        ],
        onTap: (index) {
          setPage(index);
        },

      ),
    );
  }
}

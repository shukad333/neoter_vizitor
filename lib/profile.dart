import 'package:flutter/material.dart';
import 'package:qr_test/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String number = '';
  bool isLoading = true;
  bool edit = false;

  @override
  void initState() {
    print('Init...');
    super.initState();
    _initializePref();
  }
  _initializePref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = (pref.getString('name') ?? '');
      number = (pref.getString('number') ?? '');
      isLoading = false;
    });
  }

  setPref(key,value) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile'),
      actions: [editButton()],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator():edit?inputDetails()
            : name.isEmpty? inputDetails()
            : details()
      ),
    );
  }

  void setEdit() {
    setState(() {
      edit = true;
    });
  }
  Widget editButton() {
    return IconButton(onPressed:setEdit , icon: Icon(Icons.edit));
  }
  void onChangedTitle(str) {

    setState(() {
      name = str;

    });

    // setPref('name', str);
  }

  void onChangedNumber(str) {

    setState(() {
      number = str;

    });

    // setPref('name', str);
  }

  void saveProfile() {

    setPref('name', name);
    setPref('number', number);
    setState(() {
      edit = false;
    });
  }


  Widget inputDetails() {
    return Column(
      children: [
        TextFormField(
          maxLines: 1,
          initialValue: name.isEmpty?'':name,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            // hintText: 'Title',
            labelText: 'Name',
            hintStyle: TextStyle(color: Colors.blue),
          ),
          validator: (title) =>
          title != null && title.isEmpty ? 'The title cannot be empty' : null,
          onChanged: (str) => onChangedTitle(str),
        ),
        TextFormField(
          maxLines: 1,
          initialValue: number.isEmpty?'':number,
          style: TextStyle(
            color: PRIMARY_TEXT_COLOR,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            // hintText: 'Title',
            labelText: 'Phone Number',
            hintStyle: TextStyle(color: PRIMARY_TEXT_COLOR),
          ),
          validator: (number) =>
          number != null && number.isEmpty ? 'The number cannot be empty' : null,
          onChanged: (str) => onChangedNumber(str),
        ),
        ElevatedButton(child: Text('Save'),onPressed:saveProfile),


      ],
    );
  }

  Widget details() {
    return Card(

      color: Colors.white70,

      child: Container(

        constraints: BoxConstraints(minHeight: 50),
        child: Column(

          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(

              children: [
                Icon(Icons.account_circle,color: Colors.blue,),
                Padding(padding: EdgeInsets.only(right: 12)),
                Text(name, style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,

                ),),

              ],
            ),
            Padding(padding: EdgeInsets.all(20)),

            Row(
              children: [
                Icon(Icons.phone,color: Colors.blue,),
                Padding(padding: EdgeInsets.only(right: 12)),
                Text(number,style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 20,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

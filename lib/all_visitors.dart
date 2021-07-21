import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:qr_test/constants.dart';
import 'package:qr_test/model/visitor.dart';
import 'package:qr_test/visitor_db.dart';

class AllVisitors extends StatefulWidget {
  const AllVisitors({Key? key}) : super(key: key);

  @override
  _AllVisitorsState createState() => _AllVisitorsState();
}

class _AllVisitorsState extends State<AllVisitors> {
  late List<Visitor> allVisitors;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future getNotes() async {
    setState(() {
      this.isLoading = true;
    });
    this.allVisitors = await VisitorDb.instance.readAllVisitors();
    setState(() {
      this.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visitors'),

      ),
      body: isLoading ? CircularProgressIndicator():
      groupedListView()
    );

  }

  String gp(dynamic ele) {
    List months =
    ['Jan', 'Feb', 'mar', 'apr', 'may','Jun','Jul','aug','sep','oct','nov','dec'];

    final DateTime t  = ele.time as DateTime;
    return t.day.toString()+" " +months[t.month-1];
  }
  Widget groupedListView() {

    return GroupedListView<dynamic, String>(
      elements: allVisitors,
      groupBy: (element) => gp(element),
      groupComparator: (value1,
          value2) => value2.compareTo(value1),
      itemComparator: (item1, item2) =>
          item1.name.compareTo(item2.name),
      order: GroupedListOrder.DESC,
      // useStickyGroupSeparators: true,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
      itemBuilder: (c, element) {
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0,
              vertical: 6.0),
          child: Container(
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0,
                  vertical: 10.0),
              //leading: Icon(Icons.account_circle),
              title: Text(
                element.name,
                style: TextStyle(fontSize: 16,color: PRIMARY_TEXT_COLOR_BOLD),
              ),
              subtitle: Text(
                element.number,
                style: TextStyle(fontStyle: FontStyle.italic,color: PRIMARY_TEXT_COLOR),
              ),
            ),
          ),
        );
      },
    );

  }
  Widget oldCard(index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(allVisitors[index].time.day.toString()),),
        title: Text(allVisitors[index].name),
        subtitle: Text(allVisitors[index].number),
      ),
    );
  }
}

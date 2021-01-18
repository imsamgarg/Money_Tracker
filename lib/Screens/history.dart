import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/MoneyRecord.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  static const String route = 'history';

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
          child: Hero(
            tag: "Button",
            child: FlatButton(
              onPressed: () {},
              color: redColor,
              shape: cardShape,
              child: Container(
                height: 55,
                child: Center(
                  child: Text(
                    'Delete All ',
                    style:
                        TextStyle(fontSize: fontSizeNormal, color: whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('History'),
        ),
        body: Consumer<Data>(
          builder: (context, record, child) {
            return ListView.builder(
              itemCount: record.history.length,
              itemBuilder: (context, index) {
                return Tile(
                  record: record,
                  index: index,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final Data record;
  final int index;

  Tile({this.record, this.index});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  AlertDialog buildAlertDialog(BuildContext context, Data record, int index,
      BuildContext dialogContext) {
    return AlertDialog(
      title: Text('Delete Record'),
      content: Text('Are you sure want to delete that record?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(9))),
                content: Text(
                  'Transaction Deleted',
                  style: TextStyle(color: whiteColor),
                ),
              ),
            );
            record.deleteRecord(index);
            Navigator.of(dialogContext).pop();
          },
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(dialogContext).pop(); // Dismiss alert dialog
          },
        ),
      ],
    );
  }

  static DateFormat _format = DateFormat("d MMM yyyy h:mm a (EE)");
  var visible = 0.0;

  @override
  Widget build(BuildContext context) {
    Record item = widget.record.history[widget.index];

    var color = (item.amount.isNegative) ? redColor : greenColor;
    var date = DateTime.parse(item.date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          elevation: 4,
          margin: EdgeInsets.only(left: 4, right: 4, top: 4),
          child: ListTile(
            onTap: () {
              visible = (visible == 0.0) ? 70 : 0;
              setState(() {});
            },
            leading: IconButton(
              icon: Icon(
                Icons.attach_money,
                color: color,
              ),
              onPressed: () => null,
            ),
            title: Text('$rupeeSign ${item.amount}'),
            subtitle: Text('Date: ${_format.format(date)}'),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: redColor,
              ),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext dialogContext) {
                    return buildAlertDialog(
                        context, widget.record, widget.index, dialogContext);
                  },
                );
              },
            ),
          ),
        ),
        AnimatedContainer(
          height: visible,
          curve: Curves.easeOutQuad,
          duration: Duration(milliseconds: 200),
          child: Card(
            margin: EdgeInsets.only(left: 4, right: 4),
            color: Theme.of(context).accentColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Remarks:${item.remarks}',
                  style: TextStyle(color: whiteColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

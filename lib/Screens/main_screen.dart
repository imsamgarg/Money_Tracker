import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:newmoneytracker/Screens/history.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  static const String route='main_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, History.route);
              },
            ),
          ),
        ],
      ),
      body: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<bool> _instance;

  @override
  void initState() {
    _instance = fetchData();
    super.initState();
  }

  final List<Widget> mainColumnWidgets = [
    Flexible(
      child: Center(
        child: HeadingWidget(),
      ),
    ),
    paddingWidget,
    //Heading
    Expanded(
      flex: 3,
      child: Card(
        shape: cardShape,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    balance,
                    style: normalTextStyle,
                  ),
                ),
              ),
              Flexible(
                child: BalanceText(),
              ),
            ],
          ),
        ),
      ),
    ),
    paddingWidget,
    //Balance
    Expanded(
      flex: 3,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Card(
              shape: cardShape,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Yesterday',
                        style: normalTextStyle,
                      ),
                    ),
                    Flexible(child: YesterdayDataRow()),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Card(
              shape: cardShape,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'This Week',
                        style: normalTextStyle,
                      ),
                    ),
                    Flexible(child: LastSevenDaysDataRow()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    paddingWidget,
    //Yesterday and last 7 days
    Expanded(
      flex: 3,
      child: Card(
        shape: cardShape,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    lastRecord,
                    style: normalTextStyle,
                  ),
                ),
              ),
              Expanded(child: Container(child: LastRecordText())),
            ],
          ),
        ),
      ),
    ),
    paddingWidget,
    //Last Record
    Padding(
      padding: const EdgeInsets.all(4),
      child: NewTransactionButton(),
    ),
    paddingWidget,
    //Button
  ];

  @override
  Widget build(BuildContext context) {
    print('Wtf Is Going on');
   // getList();

    return FutureBuilder(
      future: _instance,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data==true)
          return Builder(
            builder: (context) {
              return Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: mainColumnWidgets,
                ),
              );
            },
          );
          else
            return Center(child: Text('Permission Dedo Yr',style: normalTextStyle,),);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Future<bool> fetchData() async {
   PermissionStatus status=await Permission.storage.request();
   if(status.isGranted) {
     await Provider.of<Data>(context, listen: false).uploadData();
     return true;
   }
   else
     return false;
  }
}

class NewTransactionButton extends StatelessWidget {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: cardShape,
      builder: (context) => Container(
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20),
          child: BottomSheetColumn(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => _showBottomSheet(context),
      color: accentColor,
      shape: cardShape,
      child: Container(
        height: 55,
        child: Center(
          child: Text(
            'New Transaction',
            style: TextStyle(fontSize: fontSizeNormal),
          ),
        ),
      ),
    );
  }
}

class BottomSheetColumn extends StatefulWidget {
  @override
  _BottomSheetColumnState createState() => _BottomSheetColumnState();
}

class _BottomSheetColumnState extends State<BottomSheetColumn> {
  String remarks;
  double amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Enter Amount',
          style: normalTextStyle,
        ),
        TextField(
          onChanged: (value) {
            amount = double.parse(value);
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Enter Remarks',
          style: normalTextStyle,
        ),
        TextField(
          onChanged: (value) {
            remarks = value;
          },
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width - 40,
          child: Row(
            children: <Widget>[
              Consumer<Data>(
                builder: (BuildContext context, Data value, Widget child) =>
                    ActionButton(
                  function: () {
                    print(remarks);
                    print(amount);
                    if (remarks != null && amount > 0) {
                      Provider.of<Data>(context,listen: false)
                          .addTransaction(amount, remarks);
                      Navigator.pop(context);
                    }
                  },
                  text: 'Add',
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ActionButton(
                function: () {
                  if (remarks != null && amount > 0&&amount<=Provider.of<Data>(context,listen: false).balance) {
                    Provider.of<Data>(context,listen: false)
                        .addTransaction(-amount, remarks);
                    Navigator.pop(context);
                  }
                },
                text: 'Deduct',
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Function function;

  ActionButton({this.function, this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        onPressed: function,
        shape: cardShape,
        color: accentColor,
        child: Center(
          child: Text(
            text,
            style: normalTextStyle,
          ),
        ),
      ),
    );
  }
}

class HeadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Hi! Sam Garg',
      style: TextStyle(fontSize: headingFontSize, color: whiteColor),
    );
  }
}

class LastSevenDaysDataRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) {
        var color = (value.thisWeekAmount.isNegative) ? redColor : greenColor;
        return Row(
        children: <Widget>[
          Icon(
            (value.thisWeekAmount.isNegative) ? Icons.remove : Icons.add,
            color: color,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'Rs.${value.thisWeekAmount}',
            style: TextStyle(
              fontSize: fontSizeNormal + 4,
              color: color,
            ),
          ),
        ],
      );
      },
    );
  }
}

class YesterdayDataRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) {
        var color = (value.yesterdayAmount.isNegative) ? redColor : greenColor;
        return Row(
          children: <Widget>[
            Icon(
              (value.yesterdayAmount.isNegative) ? Icons.remove : Icons.add,
              color: color,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'Rs.${value.yesterdayAmount.abs()}',
              style: TextStyle(fontSize: fontSizeNormal + 4, color: color),
            ),
          ],
        );
      },
    );
  }
}

class LastRecordText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) {
        var color = (value.lastTransaction.isNegative) ? redColor : greenColor;
        return Row(
          children: <Widget>[
            Icon(
              (value.lastTransaction.isNegative) ? Icons.remove : Icons.add,
              color: color,
            ),
            Text(
              ' Rs.${value.lastTransaction.abs()}',
              style: TextStyle(color: color, fontSize: fontSizeNormal + 4),
            ),
          ],
        );
      },
    );
  }
}

class BalanceText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (BuildContext context, Data value, Widget child) => Text(
        'Rs.${value.balance}',
        style: TextStyle(fontSize: fontSizeNormal + 4),
      ),
    );
  }
}

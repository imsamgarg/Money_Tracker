import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/User.dart';
import 'package:newmoneytracker/Screens/backup_screen.dart';
import '../Widgets/main_screen_widgets.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:newmoneytracker/Screens/history.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  static const String route = 'main_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, History.route);
            },
          ),
          IconButton(
            icon: Icon(Icons.backup),
            onPressed: () {
              Navigator.pushNamed(context, BackupScreen.route);
            },
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

  Future<FirebaseApp> _initialiseFlutterApp;

  @override
  void initState() {

    _initialiseFlutterApp = Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialiseFlutterApp,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
          return MainScreenUI();
        if (snapshot.hasError)
          return Center(
            child: Text("Something Went Wrong"),
          );
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

}

class MainScreenUI extends StatefulWidget {

  @override
  _MainScreenUIState createState() => _MainScreenUIState();
}

class _MainScreenUIState extends State<MainScreenUI> {

  Future<bool> _login;
  Future<bool> _loadDataFromDisk;

  Future<bool> fetchData() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      await Provider.of<Data>(context, listen: false).uploadData();
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    _loadDataFromDisk = fetchData();
    _login = context.read<UserData>().login();
    // TODO: implement initState
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
   return  FutureBuilder(
     future: _login,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return FutureBuilder(
              future: _loadDataFromDisk,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true)
                    return Builder(
                      builder: (context) {
                        return Container(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment
                                .stretch,
                            children: mainColumnWidgets,
                          ),
                        );
                      },
                    );
                  else
                    return Center(
                      child: Text(
                        'Permission Denied',
                        style: normalTextStyle,
                      ),
                    );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          if(snapshot.hasError)
            return Center(child: Text("Login Failed"),);
          return Center(child: CircularProgressIndicator(),);
        }
    );
  }
}

class NewTransactionButton extends StatelessWidget {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: cardShape,
      builder: (context) =>
          Container(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
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
    return Hero(
      tag: "Button",
      child: FlatButton(
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
          width: MediaQuery
              .of(context)
              .size
              .width - 40,
          child: Row(
            children: <Widget>[
              Consumer<Data>(
                builder: (BuildContext context, Data value, Widget child) =>
                    ActionButton(
                      function: () {
                        print(remarks);
                        print(amount);
                        if (remarks != null && amount > 0) {
                          Provider.of<Data>(context, listen: false)
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
                  if (remarks != null &&
                      amount > 0 &&
                      amount <=
                          Provider
                              .of<Data>(context, listen: false)
                              .balance) {
                    Provider.of<Data>(context, listen: false)
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

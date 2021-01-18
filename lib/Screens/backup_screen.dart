import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Backup.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/User.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class BackupScreen extends StatelessWidget {
  static const String route = 'backup_screen';

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final userData = Provider.of<UserData>(context);
    final backup = Provider.of<Backup>(context);
    // String text;
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RestoreButton(),
            const SizedBox(
              height: 15,
            ),
            Hero(
              tag: "Button",
              child: BackupButton(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          NetworkStatus(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Backup",
              style: TextStyle(fontSize: 21),
            ),
          ),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        text: "User Name",
                        coloredText: false,
                      ),
                      Cell(
                        coloredText: true,
                        text: userData.userName,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(
                        text: "Email",
                        coloredText: false,
                      ),
                      (!userData.isUserLogged)
                          ? LoginButton(
                              text: "login",
                              function: () {
                                userData
                                    .login()
                                    .then((value) => print(value))
                                    .catchError((onError) => print(onError));
                              },
                            )
                          : Cell(
                              text: userData.email,
                              coloredText: true,
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Cell(text: "Last Backup"),
                      Cell(
                        coloredText: true,
                        text: backup.lastBackupDate,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Cell(text: ""),
              (userData.isUserLogged)
                  ? Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: LoginButton(
                        text: "Logout",
                        function: () {
                          userData
                              .logout()
                              .then((value) => print(value))
                              .catchError((onError) => print(onError));
                        },
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key key,
    this.function,
    this.text,
  }) : super(key: key);
  final String text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityResult>(
      builder: (BuildContext context, value, Widget child) {
        ConnectivityResult network = context.watch<ConnectivityResult>();
        bool isConnected = network == ConnectivityResult.none ? false : true;
        return RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                4,
              ),
            ),
          ),
          onPressed: isConnected ? function : null,
          color: Theme.of(context).accentColor,
          child: Text(
            text,
          ),
        );
      },
    );
  }
}

class RestoreButton extends StatelessWidget {
  const RestoreButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer4<ConnectivityResult,Backup,UserData,Data>(
      builder: (BuildContext context, value,b,u,d, Widget child) {
        ConnectivityResult network = context.watch<ConnectivityResult>();
        bool isConnected = network == ConnectivityResult.none ? false : true;
        return OutlineButton(
          onPressed: isConnected ? () {
            b
                .performRestore(u.userId)
                .then((value) => print(value))
                .catchError((onError) => print(onError));
          } : null,
          borderSide:
              BorderSide(color: Theme.of(context).accentColor, width: 1),
          shape: cardShape,
          child: Container(
            height: 55,
            child: Center(
              child: Text(
                'Restore',
                style: TextStyle(
                    fontSize: fontSizeNormal,
                    color: isConnected
                        ? Theme.of(context).accentColor
                        : Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Cell extends StatelessWidget {
  Cell({
    Key key,
    @required this.text,
    this.coloredText = false,
  }) : super(key: key);

  final String text;
  final bool coloredText;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2 - 16,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 18,
            color: coloredText
                ? Theme.of(context).accentColor
                : Theme.of(context).textTheme.bodyText1.color),
      ),
    );
  }
}

class BackupButton extends StatelessWidget {
  const BackupButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer4<ConnectivityResult, Backup, Data, UserData>(
      builder: (BuildContext context, value, b, d, u, Widget child) {
        ConnectivityResult network = context.watch<ConnectivityResult>();
        bool isConnected = network == ConnectivityResult.none ? false : true;
        return FlatButton(
          disabledColor: Colors.grey[700],
          onPressed: (isConnected)
              ? () {
                  b
                      .performBackup(d.getFullRecord, u.userId)
                      .then((value) => print(value))
                      .catchError((onError) => print(onError));
                }
              : null,
          color: Theme.of(context).accentColor,
          shape: cardShape,
          child: Container(
            height: 55,
            child: Center(
              child: Text(
                'Backup',
                style: TextStyle(fontSize: fontSizeNormal, color: whiteColor),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NetworkStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityResult>(
      builder: (BuildContext context, value, Widget child) {
        ConnectivityResult network = context.watch<ConnectivityResult>();
        Color color =
            network == ConnectivityResult.none ? redColor : greenColor;
        String status = network == ConnectivityResult.none
            ? "No Connected To Internet"
            : network == ConnectivityResult.mobile
                ? "Connected To Mobile Data"
                : "Connected To WIFI";
        return Container(
          height: 40,
          color: color,
          child: Center(
            child: Text(
              status,
              style: TextStyle(color: whiteColor),
            ),
          ),
        );
      },
    );
  }
}

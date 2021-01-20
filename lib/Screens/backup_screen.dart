import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Backup.dart';
import 'package:newmoneytracker/Data/Data.dart';
import 'package:newmoneytracker/Data/Loading.dart';
import 'package:newmoneytracker/Data/MoneyRecord.dart';
import 'package:newmoneytracker/Data/User.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:newmoneytracker/Widgets/widgets.dart';
import 'package:provider/provider.dart';

class BackupScreen extends StatefulWidget {
  static const String route = 'backup_screen';

  @override
  _BackupScreenState createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  Future _instance;

  Future fetchAllData() async {
    try {
      if(Provider.of<ConnectivityResult>(context,listen: false)==ConnectivityResult.none)
        return false;
      final user = Provider.of<UserData>(context, listen: false);
      bool temp = await user.loginAlreadyLoggedUser();
      if (temp) {
        bool temp = await Provider.of<Backup>(context, listen: false)
            .loadLastBackupDate(user.userId);
        if (temp) return true;
        return false;
      }
      return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _instance = fetchAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoadingClass>(
      create: (_) => LoadingClass(),
      builder: (context, _) => FutureBuilder(
        future: _instance,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Scaffold(body: Center(child: Text("Something Went Wrong")));
          if (snapshot.connectionState == ConnectionState.done)
            return Scaffold(
              appBar: AppBar(
                title: Text("Backup"),
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: RestoreButton(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Hero(
                      tag: "Button",
                      child: BackupButton(),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  LoadingWidget(),
                ],
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
                        CustomTile(
                            secondChild: UserNameText(), text: "User Name"),
                        CustomTile(secondChild: EmailText(), text: "Email"),
                        CustomTile(
                            text: "Last Backup",
                            secondChild: LastBackupDateText()),
                      ],
                    ),
                  ),
                  CustomTile(text: "", secondChild: LogoutButton()),
                ],
              ),
            );

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

//Row
class CustomTile extends StatelessWidget {
  const CustomTile({
    Key key,
    @required this.text,
    @required this.secondChild,
  }) : super(key: key);

  final String text;
  final Widget secondChild;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Cell(
            text: text,
            coloredText: false,
          ),
          secondChild,
        ],
      ),
    );
  }
}

// Custom Texts
// Custom Texts
class LastBackupDateText extends StatelessWidget {
  const LastBackupDateText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backup = Provider.of<Backup>(context);
    final userData = Provider.of<UserData>(context);
    final text = userData.isUserLogged ? backup.lastBackupDate : "Never";
    return Cell(
      coloredText: true,
      text: text,
    );
  }
}

class EmailText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context,listen: false);
    final backup=Provider.of<Backup>(context,listen: false);
    final loadingWidget = Provider.of<LoadingClass>(context,listen: false);
    // TODO: implement build
    return (!userData.isUserLogged)
        ? LoginButton(
            text: "login",
            function: () async {
              try {
                loadingWidget.startLoading();
                await userData.login();
                await backup.loadLastBackupDate(userData.userId);
                backup.notifyListener();
                loadingWidget.stopLoading();
              }  catch (e) {
                print(e);
                loadingWidget.showError("Something Went Wrong");
              }
              // loadingWidget.showSuccessMsg("User ")
            },
          )
        : Cell(
            text: userData.email,
            coloredText: true,
          );
  }
}

class UserNameText extends StatelessWidget {
  const UserNameText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    return Cell(
      coloredText: true,
      text: userData.userName,
    );
  }
}

/*
* Custom Buttons
* */

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);

    // TODO: implement build
    return (userData.isUserLogged)
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
        : SizedBox();
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
    return Consumer4<ConnectivityResult, Backup, Data, UserData>(
      builder: (BuildContext context, connectionResult, backup, moneyRecord,
          userData, Widget child) {
        ConnectivityResult network = context.watch<ConnectivityResult>();
        final loadingWidget = Provider.of<LoadingClass>(context);
        bool isConnected = network == ConnectivityResult.none ? false : true;
        bool isEnabled = isConnected &&
            userData.isUserLogged &&
            backup.lastBackupDate != "Never";

        return OutlineButton(
          // focusColor: Theme.of(context).accentColor,
          highlightedBorderColor: Theme.of(context).accentColor,
          onPressed: isEnabled
              ? () async {
                  try {
                    loadingWidget.startLoading();
                    final data = await backup.performRestore(userData.userId);
                    MoneyRecord _data = MoneyRecord.fromJson(data);
                    moneyRecord.restoreFromCloud(_data);
                    loadingWidget.stopLoading();
                    loadingWidget.showSuccessMsg("Restore Done!");
                  } catch (e) {
                    print(e);
                    loadingWidget.showError("Restore Failed");
                  }
                }
              : null,
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
                    color: isEnabled
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

class BackupButton extends StatelessWidget {
  const BackupButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<ConnectivityResult, Backup, UserData>(
      builder: (BuildContext context, connectionResult, backup, userData,
          Widget child) {
        ConnectivityResult network = connectionResult;
        final d = Provider.of<Data>(context, listen: false);
        // bool isLogged=userData.isUserLogged?true:false;
        bool isConnected = network == ConnectivityResult.none ? false : true;
        final loadingWidget = Provider.of<LoadingClass>(context);
        return FlatButton(
          disabledColor: Colors.grey[700],
          onPressed: (isConnected && userData.isUserLogged)
              ? () async {
                  try {
                    loadingWidget.startLoading();
                    await backup.performBackup(
                        d.getFullRecord, userData.userId);
                    loadingWidget.stopLoading();
                    loadingWidget.showSuccessMsg("Backup Done Successfully!!");
                  } catch (e) {
                    print(e);
                    loadingWidget.showError("SomeThing Went Wrong");
                  }
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

/*
Cell Containing Text
* */

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

/*
* NetWork Status Strip
* */

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

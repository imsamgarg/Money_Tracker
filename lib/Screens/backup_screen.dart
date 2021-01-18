import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:provider/provider.dart';
// import 'main_screen.dart';

class BackupScreen extends StatelessWidget {
  static const String route = 'backup_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
        child: Hero(
          tag: "Button",
          child: BackupButton(),
        ),
      ),
      body: Column(
        children: [
          NetworkStatus(),
        ],
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
    ConnectivityResult network = context.watch<ConnectivityResult>();
    // Color color = network == ConnectivityResult.none ? redColor : greenColor;
    bool isConnected=network==ConnectivityResult.none?false:true;
    return FlatButton(
      disabledColor: Colors.grey[700],
      onPressed: (isConnected)?() {}:null,
      color: Theme.of(context).accentColor,
      shape: cardShape,
      child: Container(
        height: 55,
        child: Center(
          child: Text(
            'Backup',
            style: TextStyle(fontSize: fontSizeNormal,color: whiteColor),
          ),
        ),
      ),
    );
  }
}

class NetworkStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectivityResult network = context.watch<ConnectivityResult>();
    Color color = network == ConnectivityResult.none ? redColor : greenColor;
    // bool isConnected=network==ConnectivityResult.none?redColor:greenColor;
    print(network);
    String status = network == ConnectivityResult.none
        ? "No Connected To Internet"
        : network == ConnectivityResult.mobile
            ? "Connected To Mobile Data"
            : "Connected To WIFI";
    return Container(
      height: 40,
      color: color,
      child: Center(
        child: Text(status,style: TextStyle(color: whiteColor),),
      ),
    );
  }
}

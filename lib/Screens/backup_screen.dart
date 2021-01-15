import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'main_screen.dart';

class BackupScreen extends StatelessWidget {
  static const String route = 'backup_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 22),
        child: Hero(
          tag: "Button",
          child: FlatButton(
            onPressed: (){},
            color: accentColor,
            shape: cardShape,
            child: Container(
              height: 55,
              child: Center(
                child: Text(
                  'Backup',
                  style: TextStyle(fontSize: fontSizeNormal),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(),
    );
  }
}

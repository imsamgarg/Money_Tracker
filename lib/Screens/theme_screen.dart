import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/ThemeManager.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:provider/provider.dart';

class ThemeScreen extends StatefulWidget {
  static const String route = "theme_screen";

  ThemeScreen({Key key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Themes"),
      ),
      body: Wrap(
        children: [
          ChangeColorButton(index: 0,color: blueAccentColor,),
          ChangeColorButton(index: 1,color: normalBlueAccentColor,),
          ChangeColorButton(index: 2,color: redAccentColor,),
          ChangeColorButton(index: 3,color: normalRedAccentColor,),
          ChangeColorButton(index: 4,color: orangeAccentColor,),
          ChangeColorButton(index: 5,color: deepOrangeAccentColor,),
          ChangeColorButton(index: 6,color: purpleAccentColor,),
          ChangeColorButton(index: 7,color: deepPurpleAccentColor,),
          // ChangeColorButton(index: 8,color: greenAccentColor,),
        ],
      ),
    );
  }
}

class ChangeColorButton extends StatelessWidget {
  static const double padding = 5.0;

  const ChangeColorButton({
    Key key, this.color, this.index,
  }) : super(key: key);

  final Color color;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Consumer<ThemeManager>(
        builder: (BuildContext context,ThemeManager value, Widget child) => GestureDetector(
          onTap: () {
            // Theme.of(context).copyWith(accentColor: Colors.blue);
            // value.changeTheme(index);
          },
          child: Container(
            height: 45,
            width: 45,
            color: color,
          ),
        ),
      ),
    );
  }
}

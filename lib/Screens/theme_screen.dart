// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/ThemeManager.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingClass extends ChangeNotifier {
  bool isLoading = false;
  String status = "";
  bool isError = false;
  bool isSuccess = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void showError(String errorMsg) {
    status = errorMsg;
    isError = true;
    notifyListeners();
    Future.delayed(Duration(seconds: 2)).then((value) {
      _hideErrorMsg();
    });
  }

  void _hideErrorMsg() {
    status = "";
    isError = false;
    notifyListeners();
  }

  void showSuccessMsg(String msg) {
    isSuccess = true;
    status = msg;
    notifyListeners();
    Future.delayed(Duration(seconds: 2)).then((value) {
      _hideSuccessMsg();
    });
  }

  void _hideSuccessMsg() {
    status = "";
    isSuccess = false;
    notifyListeners();
  }
}

class ThemeScreen extends StatefulWidget {
  static const String route = "theme_screen";

  ThemeScreen({Key key}) : super(key: key);

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoadingClass>(
      create: (context) => LoadingClass(),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Themes"),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Accent Color",
                  style: TextStyle(fontSize: 21),
                ),
              ),
              // const SizedBox(height: 10,),
              AccentColorCard(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Theme",
                  style: TextStyle(fontSize: 21),
                ),
              ),
              ThemeCard(),
              LoadingWidget(),
            ],
          ),
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer<LoadingClass>(builder: (c, v, _) {
          if (v.isLoading) return LinearProgressIndicator();
          if (v.isError)
            return Container(
              color: redColor,
              height: 40,
              width: double.infinity,
              child: Center(child: Text(v.status)),
            );
          if (v.isSuccess)
            return Container(
              color: greenColor,
              height: 40,
              child: Center(child: Text(v.status)),
            );
          return SizedBox();
        }),
      ),
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ThemeRadioTile(
            title: "Light",
            themeMode: ThemeMode.light,
          ),
        ),
        Card(
          child: ThemeRadioTile(
            title: "Dark",
            themeMode: ThemeMode.dark,
          ),
        ),
        Card(
          child: ThemeRadioTile(
            title: "System Default",
            themeMode: ThemeMode.system,
          ),
        ),
      ],
    );
  }
}

class ThemeRadioTile extends StatelessWidget {
  const ThemeRadioTile({
    Key key,
    this.themeMode,
    this.title,
  }) : super(key: key);

  final ThemeMode themeMode;
  final String title;

  @override
  Widget build(BuildContext context) {
    final shared = Provider.of<SharedPreferences>(context, listen: false);
    final loadingClass = Provider.of<LoadingClass>(context, listen: false);
    return Consumer<ThemeManager>(
      builder: (context, value, _) => RadioListTile(
          value: themeMode,
          groupValue: value.themeMode,
          title: Text(title),
          onChanged: (value) {
            loadingClass.startLoading();
            Provider.of<ThemeManager>(context, listen: false)
                .changeThemeMode(value, shared)
                .then((value) {
              print(value);
              loadingClass.stopLoading();
              loadingClass.showSuccessMsg("Theme Changed SuccessFully");
            }).catchError((e) {
              print(e);
              loadingClass.stopLoading();
              loadingClass.showError("Something Went Wrong Try Again!");
            });
          }),
    );
  }
}

class AccentColorCard extends StatelessWidget {
  const AccentColorCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Wrap(
                // alignment: WrapAlignment.spaceEvenly,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ChangeColorButton(
                    color: blueAccentColor,
                  ),
                  ChangeColorButton(
                    color: normalBlueAccentColor,
                  ),
                  ChangeColorButton(
                    color: redAccentColor,
                  ),
                  ChangeColorButton(
                    color: normalRedAccentColor,
                  ),
                  ChangeColorButton(
                    color: orangeAccentColor,
                  ),
                  ChangeColorButton(
                    color: deepOrangeAccentColor,
                  ),
                  ChangeColorButton(
                    color: purpleAccentColor,
                  ),
                  ChangeColorButton(
                    color: deepPurpleAccentColor,
                  ),
                  // ChangeColorButton(index: 8,color: greenAccentColor,),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeColorButton extends StatelessWidget {
  static const double padding = 5.0;

  const ChangeColorButton({Key key, this.color}) : super(key: key);

  final Color color;

  // final int index;
  @override
  Widget build(BuildContext context) {
    final _shared = Provider.of<SharedPreferences>(context, listen: false);
    final loadingClass = Provider.of<LoadingClass>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () {
          loadingClass.startLoading();
          Provider.of<ThemeManager>(context, listen: false)
              .changeAccentColor(color, _shared)
              .then((value) {
            loadingClass.stopLoading();
            loadingClass.showSuccessMsg("Accent Color Changed SuccessFully");
          }).catchError((e) {
            print(e);
            loadingClass.stopLoading();
            loadingClass.showError("Something Went Wrong Try Again!");
          });
        },
        child: Container(
          height: 45,
          width: 45,
          color: color,
        ),
      ),
    );
  }
}

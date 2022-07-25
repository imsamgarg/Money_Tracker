import 'package:flutter/material.dart';
import 'package:newmoneytracker/Data/Loading.dart';
import 'package:newmoneytracker/Data/ThemeManager.dart';
import 'package:newmoneytracker/Data/constants.dart';
import 'package:newmoneytracker/Widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeScreen extends StatefulWidget {
  static const String route = "theme_screen";

  ThemeScreen({Key? key}) : super(key: key);

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
              Flexible(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LoadingWidget())),
            ],
          ),
        );
      },
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    Key? key,
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
    Key? key,
    required this.themeMode,
    required this.title,
  }) : super(key: key);

  final ThemeMode themeMode;
  final String title;

  @override
  Widget build(BuildContext context) {
    final shared = Provider.of<SharedPreferences>(context, listen: false);
    final loadingClass = Provider.of<LoadingClass>(context, listen: false);
    return Consumer<ThemeManager>(
      builder: (context, value, _) => RadioListTile<ThemeMode>(
          value: themeMode,
          groupValue: value.themeMode,
          title: Text(title),
          onChanged: (value) {
            loadingClass.startLoading();
            Provider.of<ThemeManager>(context, listen: false)
                .changeThemeMode(value!, shared)
                .then((value) {
              loadingClass.stopLoading();
              loadingClass.showSuccessMsg("Theme Changed SuccessFully");
            }).catchError((e) {
              loadingClass.stopLoading();
              loadingClass.showError("Something Went Wrong Try Again!");
            });
          }),
    );
  }
}

class AccentColorCard extends StatelessWidget {
  const AccentColorCard({
    Key? key,
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

  const ChangeColorButton({Key? key, required this.color}) : super(key: key);

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

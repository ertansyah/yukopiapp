import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yukopiapps/modules/chek_login.dart';
import 'package:yukopiapps/view/introdaction_View.dart';

class CheckIntroductionPage extends StatefulWidget {
  const CheckIntroductionPage({Key? key}) : super(key: key);

  @override
  _CheckIntroductionPageState createState() => _CheckIntroductionPageState();
}

class _CheckIntroductionPageState extends State<CheckIntroductionPage> {
  late SharedPreferences _prefs;
  bool isFirstTimeUser = true;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  void initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    checkFirstTimeUser();
  }

  void checkFirstTimeUser() {
    final bool isFirstTime = _prefs.getBool('isFirstTimeUser') ?? true;
    setState(() {
      isFirstTimeUser = isFirstTime;
    });
    if (isFirstTimeUser) {
      _prefs.setBool('isFirstTimeUser', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFirstTimeUser) {
      return OnboardingPage();
    } else {
      return CheckLoginPage();
    }
  }
}

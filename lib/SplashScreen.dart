import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants.dart';
import 'HomeScreen/HomeScreen1.dart';
import 'OnboardingScreen/onBoardingScreens.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    getisFirst();
    startTime();
  }

  var splashToken;
  var splashToken1;
  final box = GetStorage();
  getToken1() async {
    // final prefs = await SharedPreferences.getInstance();
    splashToken = await box.read('userToken');
    // splashToken = prefs.getString("user_token");
    setState(() {
      splashToken1 = splashToken;
      print(splashToken1);
      print("splashToken1");
    });
  }

  var isFirst;
  getisFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('isFirst');
    setState(() {
      isFirst = boolValue;
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() async {
    await getToken1();
    print("TokenAnkit");
    print(UserToken);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              splashToken1 == null ? onboardingScreens() : HomeScreen1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bgo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('images/Vuwala.png',
                        width: MediaQuery.of(context).size.width - 25))),
            Center(
              child: Container(
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Text(
                    'CREATING THE BEST YOU FROM THE PALM OF YOUR HAND',
                    style: TextStyle(
                        fontFamily: 'regular',
                        fontSize: 13,
                        wordSpacing: 1,
                        letterSpacing: 1,
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Image(
                image: AssetImage('images/so.png'),
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset("images/st.png",
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.30),
            ),
          ],
        ),
      ),
    );
  }
}

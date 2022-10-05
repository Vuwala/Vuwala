import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SplashScreen.dart';

void main() async {
  SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        primaryColor: Color(0xffffffff),
        accentColor: Color(0xff5c9d9d),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
      },
    );
  }
}

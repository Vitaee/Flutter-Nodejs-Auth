import 'package:flutter/material.dart';
import 'package:login_register/GlobalValues/globals.dart';
import 'package:login_register/Screens/home/home.dart';
import 'Screens/login/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF2661FA),
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        //home: LoginPage());
        home: global_loggedin ? HomeScreen() : LoginPage());
  }
}

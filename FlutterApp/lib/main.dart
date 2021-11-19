import 'package:flutter/material.dart';
import 'package:login_register/GlobalValues/globals.dart';
import 'package:login_register/Screens/home/home.dart';
import 'Screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert' show json, base64, ascii;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jwt = prefs.getString("jwt");
    if (jwt == null) return "N";
    print(jwt);
    return jwt.toString();
  }

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
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            print(snapshot);
            if (!snapshot.hasData) return LoginPage();
            if (snapshot.data != "") {
              dynamic str = snapshot.data;
              dynamic jwt = str.length > 1 ? str.toString().split(".") : "";
              if (jwt.length != 3) {
                print("dsfasdfaisdşfl");
                return LoginPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return HomeScreen(str, payload);
                } else {
                  return LoginPage();
                }
              }
            } else {
              return LoginPage();
            }
          }),
    );
  }
}

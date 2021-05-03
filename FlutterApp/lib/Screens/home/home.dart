import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_register/GlobalValues/globals.dart';
import 'package:login_register/Screens/login/login.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:http/http.dart' as http;

const SERVER_IP = "http://10.0.2.2:3000";

class HomeScreen extends StatelessWidget {
  HomeScreen(this.jwt, this.payload);

  factory HomeScreen.fromBase64(String jwt) => HomeScreen(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: FutureBuilder(
              future: http.read(Uri.parse('$SERVER_IP/user/data'),
                  headers: {"authorization": jwt}),
              builder: (context, snapshot) => snapshot.hasData
                  ? Column(
                      children: <Widget>[
                        Text('$payload'),
                        Text("${payload['email']}, here's the data:"),
                        Text(
                          snapshot.data,
                        )
                      ],
                    )
                  : snapshot.hasError
                      ? Text("An error occurred")
                      : CircularProgressIndicator()),
        ),
      );
}

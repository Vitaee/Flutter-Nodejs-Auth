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
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: FutureBuilder(
          future: http.read(Uri.parse('$SERVER_IP/user/data'),
              headers: {"authorization": jwt}),
          builder: (context, snapshot) => snapshot.hasData
              ? ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                          Container(
                              width: 125.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    padding: EdgeInsets.only(right: 10),
                                    icon: Icon(Icons.menu),
                                    color: Colors.white,
                                    onPressed: () {},
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                      child: Row(
                        children: <Widget>[
                          Text('Healthy',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0)),
                          SizedBox(width: 10.0),
                          Text('Food',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0))
                        ],
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      height: MediaQuery.of(context).size.height - 150.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(75.0)),
                      ),
                      child: ListView(
                        primary: false,
                        padding: EdgeInsets.only(left: 1.0, right: 1.0),
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 45.0, left: 25, right: 20),
                              child: Container(
                                  height: MediaQuery.of(context).size.height -
                                      255.0,
                                  child: ListView(children: [
                                    _buildFoodItem('assets/falafel.png',
                                        'Falafel Beet Hummus ', '\$24.00'),
                                    _buildFoodItem('assets/buddha.png',
                                        'Buddha bowl', '\$22.00'),
                                    _buildFoodItem('assets/salad.png',
                                        'Salad with Salmon', '\$22.00'),
                                    _buildFoodItem('assets/falafel.png',
                                        'Falafel Beet Hummu', '\$22.00'),
                                    _buildFoodItem('assets/buddha.png',
                                        'Buddha bowl', '\$22.00'),
                                    _buildFoodItem('assets/salad.png',
                                        'Salad with Salmon', '\$22.00'),
                                    _buildFoodItem('assets/falafel.png',
                                        'Falafel Beet Hummu', '\$22.00'),
                                    _buildFoodItem('assets/beetroot.png',
                                        'Beetroot Hommus', '\$22.00'),
                                    _buildFoodItem('assets/salad.png',
                                        'Salad with Salmon', '\$24.00'),
                                    _buildFoodItem('assets/beetroot.png',
                                        'Beetroot Hommus', '\$26.00'),
                                  ]))),
                          BottomNavigationBar(
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Home',
                                  backgroundColor: Colors.red,
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.search),
                                  label: 'Search',
                                  backgroundColor: Colors.green,
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.account_circle),
                                  label: 'Profile',
                                  backgroundColor: Colors.purple,
                                ),
                              ]),
                        ],
                      ),
                    )
                  ],
                )
              : snapshot.hasError
                  ? Text("An error occurred")
                  : CircularProgressIndicator()),
    );
  }

  Widget _buildFoodItem(String imgPath, String foodName, String price) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      tag: imgPath,
                      child: Image(
                          image: AssetImage(imgPath),
                          fit: BoxFit.cover,
                          height: 75.0,
                          width: 75.0)),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(foodName,
                            style: TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.bold)),
                        Text(price,
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.grey))
                      ])
                ])),
                IconButton(
                    icon: Icon(
                      Icons.arrow_right_outlined,
                      size: 30,
                    ),
                    color: Colors.black,
                    onPressed: () {})
              ],
            )));
  }
}

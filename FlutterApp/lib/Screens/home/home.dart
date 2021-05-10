import 'package:flutter/material.dart';
import 'package:login_register/Models/FoodsModel.dart';
import 'package:login_register/Screens/Detail/details.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:http/http.dart' as http;
import 'package:login_register/Screens/menu/draw_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

const SERVER_IP = "http://10.0.2.2:3000";

class HomeScreen extends StatefulWidget {
  HomeScreen(this.jwt, this.payload);

  factory HomeScreen.fromBase64(String jwt) => HomeScreen(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
  }

  Future<List<Foods>> fetchFood() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/foods'),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((myMap) => Foods.fromJson(myMap))
          .toList();
    } else {
      throw Exception("Failed to load post!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Healthy fOOD',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0)),
        ),
        drawer: SideMenu(),
        backgroundColor: Color(0xFF4478FA),
        body: Container(
          height: double.infinity,
          child: FutureBuilder(
              key: PageStorageKey("$context"),
              future: fetchFood(),
              builder: (BuildContext context,
                      AsyncSnapshot<List<Foods>> snapshot) =>
                  snapshot.hasData
                      ? Column(
                          children: <Widget>[
                            // Text(snapshot.data), // bu kısım düzeltilecek.

                            Container(
                              height: MediaQuery.of(context).size.height * 0.83,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(1.0)),
                              ),
                              child: ListView(
                                primary: false,
                                padding: EdgeInsets.only(left: 1.0, right: 1.0),
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 45.0, left: 25, right: 20),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              100.0,
                                          child: ListView.builder(
                                              itemCount: snapshot.data.length,
                                              itemBuilder: (context, index) {
                                                return _buildFoodItem(
                                                    context,
                                                    snapshot.data[index].image,
                                                    snapshot
                                                        .data[index].foodName,
                                                    snapshot
                                                        .data[index].sharedBy);
                                              }))),
                                ],
                              ),
                            ),
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
                        )
                      : snapshot.hasError
                          ? Center(child: Text("An error occurred"))
                          : CircularProgressIndicator()),
        ));
  }

  Widget _buildFoodItem(
      BuildContext context, String imgPath, String foodName, String price) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DetailScreen(
                        foodName: foodName,
                      )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      tag: price,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(imgPath,
                            fit: BoxFit.cover, height: 75.0, width: 75.0),
                      )),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(foodName,
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.bold)),
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

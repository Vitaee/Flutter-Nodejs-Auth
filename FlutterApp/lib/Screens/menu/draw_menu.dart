import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_register/Screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:login_register/Models/UsersModel.dart';

const SERVER_IP = "http://10.0.2.2:3000";

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
  }

  Future<List<UserData>> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic token = prefs.getString("jwt");

    final response = await http.get(Uri.parse('$SERVER_IP/user/data'),
        headers: {'authorization': token});

    if (response.statusCode != 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse.map((myMap) => UserData.fromJson(myMap)).toList();
    }

    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((myMap) => UserData.fromJson(myMap)).toList();
    //return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
          future: fetchUserData(),
          builder: (BuildContext context,
                  AsyncSnapshot<List<UserData>> snapshot) =>
              snapshot.hasData
                  ? Column(
                      children: <Widget>[
                        UserAccountsDrawerHeader(
                          accountName: Text("${snapshot.data?[0].username}"),
                          accountEmail: Text("${snapshot.data?[0].email}"),
                          currentAccountPicture: new Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://www.freeiconspng.com/uploads/profile-icon-9.png"),
                              ),
                            ),
                          ),
                          //currentAccountPicture: Image.network(
                          //  "https://media-exp1.licdn.com/dms/image/C4D03AQE0Tn3UciIOUQ/profile-displayphoto-shrink_200_200/0/1617999936061?e=1623888000&v=beta&t=11NikCkvRx2eildN433FqVhvjEmzwFmu0S5dIlr3gO4"),
                        ),
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.home),
                                title: Text("Homepage"),
                                trailing: Icon(Icons.chevron_right),
                              ),
                              ListTile(
                                leading: Icon(Icons.search),
                                title: Text("Search"),
                                trailing: Icon(Icons.chevron_right),
                              ),
                              ListTile(
                                leading: Icon(Icons.account_box),
                                title: Text("Profile"),
                                trailing: Icon(Icons.chevron_right),
                              ),
                              Divider(),
                              InkWell(
                                //inkwell ile küçük kısımlara bile ontap ekleyebiliyoruz.
                                onTap: () {
                                  setState(() {
                                    logOut();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  });
                                },
                                splashColor: Colors.greenAccent,
                                child: ListTile(
                                  leading: Icon(Icons.golf_course),
                                  title: Text("Logout"),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : snapshot.hasError
                      ? Center(
                          child: Text("${snapshot.error}"),
                        )
                      : CircularProgressIndicator()),
    );
  }
}

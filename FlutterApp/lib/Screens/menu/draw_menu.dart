import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_register/Screens/login/login.dart';
import 'package:login_register/core/widget/divider/divider_widget.dart';
import 'package:login_register/core/widget/error/error_widget.dart';
import 'package:login_register/core/widget/listTile/drawer_listTile_widget.dart';
import 'package:login_register/core/widget/loading/loading_widget.dart';
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
          builder:
              (BuildContext context, AsyncSnapshot<List<UserData>> snapshot) =>
                  snapshot.hasData
                      ? _buildMainBody(snapshot, context)
                      : snapshot.hasError
                          ? ErrorDataView()
                          : LoadingView()),
    );
  }

  Column _buildMainBody(
      AsyncSnapshot<List<UserData>> snapshot, BuildContext context) {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("${snapshot.data?[0].username}"),
          accountEmail: Text("${snapshot.data?[0].email}"),
          currentAccountPicture: new Container(
            decoration: _buildDecoration(),
          ),
        ),
        Expanded(
          child: _buildListView(context),
        )
      ],
    );
  }

  BoxDecoration _buildDecoration() {
    return new BoxDecoration(
      shape: BoxShape.circle,
      image: new DecorationImage(
        fit: BoxFit.contain,
        image: ImagePath.profile.profileToAsset(),
      ),
    );
  }

  ListView _buildListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerMenuListTileView(
          icon: Icons.home,
          title: ListTileTexts.Homepage.name,
        ),
        DrawerMenuListTileView(
          icon: Icons.search,
          title: ListTileTexts.Search.name,
        ),
        DrawerMenuListTileView(
          icon: Icons.account_box,
          title: ListTileTexts.Profile.name,
        ),
        DividerView(),
        _buildLogoutListTile(context),
      ],
    );
  }

  InkWell _buildLogoutListTile(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          logOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      },
      splashColor: Colors.greenAccent,
      child: DrawerMenuListTileView(
        icon: Icons.logout,
        title: ListTileTexts.Logout.name,
      ),
    );
  }
}

enum ListTileTexts { Homepage, Search, Profile, Logout }
enum ImagePath { profile }

extension ImageExtension on ImagePath {
  String profilePath() {
    return "assets/images/${ImagePath.profile.name}.png";
  }

  AssetImage profileToAsset() {
    return AssetImage(profilePath());
  }
}

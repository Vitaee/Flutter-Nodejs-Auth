import 'package:flutter/material.dart';
import 'package:login_register/Screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Sedat Dayan"),
            accountEmail: Text("dayan.sedat1998@gmail.com"),
            currentAccountPicture: new Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "https://media-exp1.licdn.com/dms/image/C4D03AQE0Tn3UciIOUQ/profile-displayphoto-shrink_200_200/0/1617999936061?e=1623888000&v=beta&t=11NikCkvRx2eildN433FqVhvjEmzwFmu0S5dIlr3gO4"),
                ),
              ),
            ),
            //currentAccountPicture: Image.network(
            //  "https://media-exp1.licdn.com/dms/image/C4D03AQE0Tn3UciIOUQ/profile-displayphoto-shrink_200_200/0/1617999936061?e=1623888000&v=beta&t=11NikCkvRx2eildN433FqVhvjEmzwFmu0S5dIlr3gO4"),
            otherAccountsPictures: [
              CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text("SD"),
              ),
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text("DS"),
              ),
            ],
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
                        MaterialPageRoute(builder: (context) => LoginPage()),
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
      ),
    );
  }
}
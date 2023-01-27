import 'package:flutter/material.dart';
import 'package:login_register/Models/FoodsModel.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:http/http.dart' as http;
import 'package:login_register/Screens/detail/details.dart';
import 'package:login_register/Screens/menu/draw_menu.dart';
import 'package:login_register/core/widget/error/error_widget.dart';
import 'package:login_register/core/widget/loading/loading_widget.dart';
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
  final String appTitle = 'Healthy Food';
  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
  }

  bool isLoading = false;
  int pageCount = 1;
  ScrollController? _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(() => {_scrollListener()});
  }

  Future<List<Foods>> fetchFood(int pageCount) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/foods?page=$pageCount'),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((myMap) => Foods.fromJson(myMap))
          .toList();
    } else {
      if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception("Failed to load post!");
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      drawer: SideMenu(),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        key: PageStorageKey("$context"),
        future: fetchFood(pageCount),
        builder: (BuildContext context, AsyncSnapshot<List<Foods>> snapshot) =>
            snapshot.hasData && snapshot.data!.length >= 1
                ? _buildMainBody(context, snapshot)
                : snapshot.hasError
                    ? ErrorDataView()
                    : snapshot.data != null
                        ? NullDataView()
                        : LoadingView(),
      ),
      bottomNavigationBar: _customBottomNavigateBar(),
    );
  }

  AppBar _buildCustomAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF4478FA),
      title: Text(appTitle,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22.0)),
    );
  }

  Container _buildMainBody(
      BuildContext context, AsyncSnapshot<List<Foods>> snapshot) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 0.83,
      color: Colors.white,
      child: _buildListViewBuilder(snapshot),
    );
  }

  ListView _buildListViewBuilder(AsyncSnapshot<List<Foods>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data!.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return _buildFoodItem(
            context,
            snapshot.data?[index].image,
            snapshot.data?[index].foodName,
            snapshot.data?[index].authorName,
            snapshot.data?[index].recipeInstructions,
            snapshot.data?[index].recipeIngredient,
            index,
          );
        });
  }

  BottomNavigationBar _customBottomNavigateBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        _bottomNavigateItems(Icons.home, NavigateBarTitles.Home.name),
        _bottomNavigateItems(Icons.search, NavigateBarTitles.Search.name),
        _bottomNavigateItems(
            Icons.account_circle, NavigateBarTitles.Profile.name),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavigateItems(
      IconData icon, String labelText) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: labelText,
    );
  }

  _scrollListener() {
    if (_scrollController!.offset >=
            _scrollController!.position.maxScrollExtent &&
        !_scrollController!.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("Running load more..");
          pageCount = pageCount + 1;
          fetchFood(pageCount);
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    super.dispose();
  }

  Widget _buildFoodItem(
      BuildContext context,
      String? imgPath,
      String? foodName,
      String? sharedBy,
      List<String>? description,
      List<String>? details,
      int? index) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailScreen(
                  foodName: foodName.toString(),
                  sharedBy: sharedBy.toString(),
                  description: description!,
                  details: details,
                  image: imgPath.toString(),
                )));
      },
      leading: _buildListTileLeading(imgPath),
      title: _buildListTileTitle(foodName),
      subtitle: _buildListTileSubtitle(sharedBy),
      trailing: _buildListTileTrailing(context),
    );
  }

  ClipRRect _buildListTileLeading(String? imgPath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.network(imgPath.toString(),
          fit: BoxFit.cover, height: 75.0, width: 75.0),
    );
  }

  Text _buildListTileTitle(String? foodName) {
    return Text(
      foodName.toString(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  Text _buildListTileSubtitle(String? sharedBy) {
    return Text(
      "by " + sharedBy.toString(),
      style: TextStyle(fontSize: 14.0, color: Colors.grey),
    );
  }

  Icon _buildListTileTrailing(BuildContext context) {
    return Icon(
      Icons.arrow_right_outlined,
      size: MediaQuery.of(context).size.height * 0.035,
    );
  }
}

class NullDataView extends StatelessWidget {
  const NullDataView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("There is no foods.."),
    );
  }
}

enum NavigateBarTitles { Home, Search, Profile }

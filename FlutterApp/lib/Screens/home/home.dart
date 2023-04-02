import 'package:flutter/material.dart';
import 'package:login_register/Models/FoodsModel.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:http/http.dart' as http;
import 'package:login_register/Screens/detail/details.dart';
import 'package:login_register/Screens/menu/draw_menu.dart';
import 'package:login_register/core/const/border/border_radi.dart';
import 'package:login_register/core/const/enums/icon_enums/icon_enums.dart';
import 'package:login_register/core/const/responsive/responsive.dart';
import 'package:login_register/core/widget/error/error_widget.dart';
import 'package:login_register/core/widget/loading/loading_widget.dart';
import 'package:login_register/core/widget/nullData/null_data_widget.dart';
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
  final String appTitle = 'Hello, Sedat';
  final String txtFormTitle = "Search Food...";
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.grey),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: 'Open user cart',
          onPressed: () {},
        ),
      ],
    );
  }

  _buildMainBody(BuildContext context, AsyncSnapshot<List<Foods>> snapshot) {
    return Padding(
      padding: context.minAllPadding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeText(),
            SizedBox(
              height: context.dynamicHeight(0.02),
            ),
            _buildTextFormContainer(context),
            SizedBox(
              height: context.dynamicHeight(0.02),
            ),
            Container(
              height: context.dynamicHeight(0.7),
              child: _buildGridViewBuilder(snapshot),
            ),
          ],
        ),
      ),
    );
  }

  Text _buildWelcomeText() {
    return Text(appTitle,
        style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 22.0));
  }

  Container _buildTextFormContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 5),
        ),
      ]),
      height: context.dynamicHeight(0.05),
      width: context.dynamicWidth(0.7),
      child: _buildCustomTextFormField(context),
    );
  }

  TextFormField _buildCustomTextFormField(BuildContext context) {
    return TextFormField(
      decoration: _buildTextFormDecoration(context),
    );
  }

  InputDecoration _buildTextFormDecoration(BuildContext context) {
    return InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: context.midLTRB,
        isDense: true,
        prefixIcon: Icon(Icons.search),
        enabledBorder: _buildEnabledBorder(),
        focusedBorder: _buildFocusedBorder(),
        hintText: txtFormTitle);
  }

  OutlineInputBorder _buildEnabledBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadi.highCircular);
  }

  OutlineInputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        borderRadius: BorderRadi.highCircular);
  }

  _buildGridViewBuilder(AsyncSnapshot<List<Foods>> snapshot) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        crossAxisSpacing: context.dynamicHeight(0.01),
        mainAxisSpacing: context.dynamicHeight(0.01),
        mainAxisExtent: context.dynamicHeight(0.4),
        maxCrossAxisExtent: context.dynamicHeight(0.4),
      ),
      controller: _scrollController,
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailScreen(
                      foodName: snapshot.data?[index].foodName.toString() ?? "",
                      sharedBy:
                          snapshot.data?[index].authorName.toString() ?? "",
                      description:
                          snapshot.data?[index].foodDescription.toString() ??
                              "",
                      details: snapshot.data?[index].recipeInstructions,
                      image: snapshot.data?[index].image.toString() ?? "",
                      receipt: snapshot.data?[index].recipeNutrition,
                    )));
          },
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 5),
              ),
            ], color: Colors.white, borderRadius: BorderRadi.midCircular),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadi.midCircular,
                  child: Image.network(
                      snapshot.data?[index].image.toString() ?? "",
                      height: context.dynamicHeight(0.2),
                      fit: BoxFit.contain),
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                Text(
                  snapshot.data?[index].foodName.toString() ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                Text(
                  snapshot.data?[index].foodDescription.toString() ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
                SizedBox(
                  height: context.dynamicHeight(0.02),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconEnums.ic_kcal.toImage,
                    Text(snapshot.data?[index].recipeCategory![0].toString() ??
                        "asd")
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
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
}

enum NavigateBarTitles { Home, Search, Profile }

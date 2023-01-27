// import 'package:flutter/material.dart';
// import 'package:login_register/Models/FoodsModel.dart';
// import 'dart:convert' show json, base64, ascii;
// import 'package:http/http.dart' as http;
// import 'package:login_register/Screens/detail/details.dart';
// import 'package:login_register/Screens/menu/draw_menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:convert';

// const SERVER_IP = "http://10.0.2.2:3000";

// class HomeScreen extends StatefulWidget {
//   HomeScreen(this.jwt, this.payload);

//   factory HomeScreen.fromBase64(String jwt) => HomeScreen(
//       jwt,
//       json.decode(
//           ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

//   final String jwt;
//   final Map<String, dynamic> payload;

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   logOut() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('jwt');
//   }

//   bool isLoading = false;
//   int pageCount = 1;
//   ScrollController? _scrollController;
//   @override
//   void initState() {
//     super.initState();
//     _scrollController = new ScrollController(initialScrollOffset: 5.0)
//       ..addListener(() => {_scrollListener()});
//   }

//   Future<List<Foods>> fetchFood(int pageCount) async {
//     final response = await http.get(
//       Uri.parse('http://10.0.2.2:3000/foods?page=$pageCount'),
//     );
//     if (response.statusCode == 200) {
//       return (json.decode(response.body) as List)
//           .map((myMap) => Foods.fromJson(myMap))
//           .toList();
//     } else {
//       if (response.statusCode == 404) {
//         return [];
//       } else {
//         throw Exception("Failed to load post!");
//       }
//     }
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF4478FA),
//         title: Text('Healthy Food',
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22.0)),
//       ),
//       drawer: SideMenu(),
//       backgroundColor: Colors.white,
//       body: FutureBuilder(
//         key: PageStorageKey("$context"),
//         future: fetchFood(pageCount),
//         builder: (BuildContext context, AsyncSnapshot<List<Foods>> snapshot) =>
//             snapshot.hasData && snapshot.data!.length >= 1
//                 ? Container(
//                     height: MediaQuery.of(context).size.height * 0.83,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.only(topLeft: Radius.circular(1.0)),
//                     ),
//                     child: ListView(
//                       primary: false,
//                       children: <Widget>[
//                         Padding(
//                             padding:
//                                 EdgeInsets.only(top: 5.0, left: 18, right: 18),
//                             child: Container(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.8,
//                                 child: ListView.builder(
//                                     itemCount: snapshot.data!.length,
//                                     controller: _scrollController,
//                                     itemBuilder: (context, index) {
//                                       return _buildFoodItem(
//                                         context,
//                                         snapshot.data?[index].imageSource,
//                                         snapshot.data?[index].foodTitle,
//                                         snapshot.data?[index].madeBy,
//                                         snapshot.data?[index].methods,
//                                         snapshot.data?[index].ingredients,
//                                         index,
//                                       );
//                                     }))),
//                       ],
//                     ),
//                   )
//                 : snapshot.hasError
//                     ? Center(child: Text("An error accured."))
//                     : snapshot.data != null
//                         ? Center(
//                             child: Text("There is no foods.."),
//                           )
//                         : CircularProgressIndicator(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//             backgroundColor: Colors.red,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//             backgroundColor: Colors.green,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_circle),
//             label: 'Profile',
//             backgroundColor: Colors.purple,
//           ),
//         ],
//       ),
//     );
//   }

//   _scrollListener() {
//     if (_scrollController!.offset >=
//             _scrollController!.position.maxScrollExtent &&
//         !_scrollController!.position.outOfRange) {
//       setState(() {
//         print("comes to bottom $isLoading");
//         isLoading = true;

//         if (isLoading) {
//           print("Running load more..");
//           pageCount = pageCount + 1;

//           fetchFood(pageCount);
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController!.dispose();
//     super.dispose();
//   }

//   Widget _buildFoodItem(BuildContext context, String? imgPath, String? foodName,
//       String? sharedBy, List? description, List? details, int? index) {
//     return Padding(
//         padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 18.0),
//         child: InkWell(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => DetailScreen(
//                         foodName: foodName.toString(),
//                         sharedBy: sharedBy.toString(),
//                         description: description,
//                         details: details,
//                         image: imgPath.toString(),
//                       )));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 3,
//                       blurRadius: 3,
//                       offset: Offset(0, 2), // changes position of shadow
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(25.0),
//                   color: Colors.grey.shade300),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                       child: Row(children: [
//                     Hero(
//                         tag: int.parse(index.toString()),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10.0),
//                           child: Image.network(imgPath.toString(),
//                               fit: BoxFit.cover, height: 75.0, width: 75.0),
//                         )),
//                     SizedBox(width: 10.0),
//                     Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                               "${foodName.toString().length > 35 ? foodName.toString().substring(0, 35) : foodName}",
//                               style: TextStyle(
//                                   fontSize: 13.0, fontWeight: FontWeight.bold)),
//                           Text(sharedBy.toString(),
//                               style:
//                                   TextStyle(fontSize: 14.0, color: Colors.grey))
//                         ])
//                   ])),
//                   IconButton(
//                     icon: Icon(
//                       Icons.arrow_right_outlined,
//                       size: 30,
//                     ),
//                     color: Colors.black,
//                     onPressed: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => DetailScreen(
//                                 foodName: foodName.toString(),
//                                 sharedBy: sharedBy.toString(),
//                                 description: description,
//                                 details: details,
//                                 image: imgPath.toString(),
//                               )));
//                     },
//                   )
//                 ],
//               ),
//             )));
//   }
// }

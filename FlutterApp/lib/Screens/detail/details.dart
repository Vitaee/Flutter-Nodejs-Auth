import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    Key? key,
    required this.foodName,
    required this.sharedBy,
    required this.image,
    required this.description,
    required this.details,
  }) : super(key: key);
  final String foodName;
  final String sharedBy;
  final String image;
  final dynamic description, details;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.star_border_rounded,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {})
          ],
        ),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 4),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 1,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  ),
                ),
                FoodTitleWidget(
                    productName: widget.foodName, productHost: widget.sharedBy),
                SizedBox(
                  height: 5,
                ),
                PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: TabBar(
                    labelColor: Color(0xFF4478FA),
                    indicatorColor: Color(0xFF4478FA),
                    unselectedLabelColor: Color(0xFFa4a1a1),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(
                        text: 'Food Details',
                      ),
                      Tab(
                        text: 'Food Reviews',
                      ),
                    ], // list of tabs
                  ),
                ),
                Card(
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(25)),
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: TabBarView(
                      children: [
                        Container(
                          color: Colors.white24,
                          child: DetailContentMenu(widget.details),
                        ),
                        Container(
                          color: Colors.white24,
                          child: DetailContentMenu(widget.description),
                        ), // class name
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class FoodTitleWidget extends StatelessWidget {
  String productName;

  String productHost;

  FoodTitleWidget({
    Key? key,
    required this.productName,
    required this.productHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(5.0),
      color: Colors.white70,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                children: <Widget>[
                  Text(
                    productName,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text(
                  productHost,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1f1f1f),
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DetailContentMenu extends StatelessWidget {
  DetailContentMenu(this.detail);

  final List detail;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: detail.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: Text(
            "•  " + detail[index],
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                height: 1.75),
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }
}

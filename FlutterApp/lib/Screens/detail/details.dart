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
          backgroundColor: Color(0xFFFAFAFA),
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
                  Icons.business_center,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {})
          ],
        ),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Column(
              children: <Widget>[
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(widget.image),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  elevation: 1,
                  margin: EdgeInsets.all(80),
                ),
                FoodTitleWidget(
                    productName: widget.foodName,
                    productPrice: "\$96.00",
                    productHost: widget.sharedBy),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 15,
                ),
                PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: TabBar(
                    labelColor: Color(0xFFfd3f40),
                    indicatorColor: Color(0xFFfd3f40),
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
                Container(
                  height: 150,
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
  String productPrice;
  String productHost;

  FoodTitleWidget({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              productName,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              productPrice,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
          ],
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
          child: Text(
            detail[index],
            style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                height: 1.50),
            textAlign: TextAlign.justify,
          ),
        );
      },
    );
  }
}

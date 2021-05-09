import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    Key key,
    this.foodName,
  }) : super(key: key);
  final String foodName;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4478FA),
      appBar: AppBar(
        leading: InkWell(
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Details',
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height - 82.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent),
              Positioned(
                  top: 75.0,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45.0),
                            topRight: Radius.circular(45.0),
                          ),
                          color: Colors.white),
                      height: MediaQuery.of(context).size.height - 100.0,
                      width: MediaQuery.of(context).size.width)),
            ],
          ),
          Text(widget.foodName),
        ],
      ),
    );
  }
}

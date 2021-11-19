import 'package:flutter/material.dart';

class PopUpDialog extends StatelessWidget {
  //const PopUpDialog({Key? key}) : super(key: key);

  final String title;
  final String content;
  final dynamic page;

  PopUpDialog({required this.title, required this.content, required this.page});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => page)),
          //Navigator.pop(context, 'Ok'),
          child: const Text('Ok'),
        ),
      ],
      elevation: 24.0,
      backgroundColor: Colors.white,
      //shape: CircleBorder(),
    );
  }
}

import 'package:flutter/material.dart';

class DividerView extends StatelessWidget {
  const DividerView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Theme.of(context).primaryColor,
    );
  }
}

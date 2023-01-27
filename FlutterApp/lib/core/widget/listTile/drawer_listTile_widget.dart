import 'package:flutter/material.dart';

class DrawerMenuListTileView extends StatelessWidget {
  final IconData icon;
  final String title;

  const DrawerMenuListTileView({
    Key? key,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
    );
  }
}

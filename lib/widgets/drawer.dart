import 'package:flutter/material.dart';
import 'package:proto_app/screens/historyScreen.dart';

class ScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100,
            child: DrawerHeader(
              padding: EdgeInsets.only(top: 25, left: 30),
              child: Text(
                'Proto App',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
          ),
          ListTile(
            title: Text('Notifications History'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

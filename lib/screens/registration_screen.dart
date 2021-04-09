import 'package:flutter/material.dart';
import 'package:proto_app/screens/signIn_screen.dart';
import 'package:proto_app/screens/signUp_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const route = '/registrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'SIGN IN'),
              Tab(text: 'SIGN UP'),
            ],
          ),
          title: Text('Welcome'),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            SignInScreen(),
            SignUpScreen(),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:proto_app/screens/landing_screen.dart';
import 'package:proto_app/screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'bolt-regular',
      ),
      home: LandingScreen(),
      routes: {
        RegistrationScreen.route: (ctx) => RegistrationScreen(),
      },
    );
  }
}

class PushNotificationCheck extends StatefulWidget {
  @override
  _PushNotificationCheckState createState() => _PushNotificationCheckState();
}

class _PushNotificationCheckState extends State<PushNotificationCheck> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  Color bg = Colors.purple;

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((event) {
      print(
          'meesage event occured---------------------------------------------------');
      print(event.messageId);
      print(event.messageType);
    });

    var results;

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      setState(() {
        results = value;

        print('here');

        if (results != null) {
          setState(() {
            bg = Colors.red;
          });
        }
      });
    });

    print('$results ----------------------------------------initial message');

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        bg = Colors.yellow;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Column(
            children: [
              Text(messageTitle),
              Text(notificationAlert),
            ],
          ),
        ));
  }
}

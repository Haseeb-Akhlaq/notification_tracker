import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController1 = TextEditingController();
  TextEditingController contentController1 = TextEditingController();

  TextEditingController nameController2 = TextEditingController();
  TextEditingController contentController2 = TextEditingController();

  String selectedSound1 = 'shot';
  DateTime selectedDate1 = DateTime.now();
  String notificationName1 = 'Save it';
  String notificationContent1 = 'First notification';

  String selectedSound2 = 'siren';
  DateTime selectedDate2 = DateTime.now();
  String notificationName2 = 'Call the police';
  String notificationContent2 = 'calling 911';

  String seletedButton = '1';

  var time;

  bool isLoading = false;

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));

    time = tz.TZDateTime.from(
      seletedButton == '1' ? selectedDate1 : selectedDate2,
      tz.local,
    );
  }

  Future<tz.TZDateTime> configureLocalTimeZone2(DateTime date) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Detroit'));

    final selectDate = tz.TZDateTime.from(
      date,
      tz.local,
    );
    return selectDate;
  }

  FlutterLocalNotificationsPlugin fltrNotification;

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  retreivingSharedPreferences() async {
    setState(() {
      isLoading = true;
    });
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('notificationData')) {
      setState(() {
        nameController1.text = notificationName1;
        contentController1.text = notificationContent1;

        nameController2.text = notificationName2;
        contentController2.text = notificationContent2;
      });

      return;
    }
    final extractedUserData =
        json.decode(prefs.getString('notificationData')) as Map<String, Object>;
    notificationName1 = extractedUserData['name1'];
    notificationContent1 = extractedUserData['content1'];
    selectedSound1 = extractedUserData['sound1'];
    selectedDate1 = DateTime.parse(extractedUserData['time1']);
    notificationName2 = extractedUserData['name2'];
    notificationContent2 = extractedUserData['content2'];
    selectedSound2 = extractedUserData['sound2'];
    selectedDate2 = DateTime.parse(
      extractedUserData['time2'],
    );

    nameController1.text = notificationName1;
    contentController1.text = notificationContent1;

    nameController2.text = notificationName2;
    contentController2.text = notificationContent2;
  }

  Future<void> savingSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final notificationData = json.encode({
      'name1': nameController1.text,
      'content1': contentController1.text,
      'time1': selectedDate1.toString(),
      'sound1': selectedSound1,
      'name2': nameController2.text,
      'content2': contentController2.text,
      'time2': selectedDate2.toString(),
      'sound2': selectedSound2,
    });

    sharedPreferences.setString('notificationData', notificationData);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    retreivingSharedPreferences();

    Timer(Duration(seconds: 2), () {
      var androidInitilize = AndroidInitializationSettings('logo');
      var iOSinitilize = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      var initilizationsSettings = new InitializationSettings(
          android: androidInitilize, iOS: iOSinitilize);
      fltrNotification = new FlutterLocalNotificationsPlugin();
      fltrNotification.initialize(
        initilizationsSettings,
        onSelectNotification: notificationSelected,
      );
    });

    setState(() {
      isLoading = false;
    });
  }

  Future _showNotification1(String name, String content, String sound) async {
    var androidDetails = new AndroidNotificationDetails(
      "Channel ID 1",
      "Desi programmer 1",
      "This is my channel 1",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('siren'),
    );
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await configureLocalTimeZone();

    await fltrNotification.zonedSchedule(
      0,
      name,
      content,
      time,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
    );
  }

  Future _showNotification2(String name, String content, String sound) async {
    print('notfication 2 called');
    var androidDetails = new AndroidNotificationDetails(
      "Channel ID",
      "Shot Notification",
      "This is my channel",
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('shot'),
    );
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    await configureLocalTimeZone();

    //await fltrNotification.show(4, 'wer', 'wer', generalNotificationDetails);

    await fltrNotification.zonedSchedule(
      4,
      name,
      content,
      time,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
    );
  }

  Future _selectAgainNotification1(DateTime time) async {
    var androidDetails = new AndroidNotificationDetails(
      "Channel ID 3",
      "Select Again Notification",
      "This is my channel",
      importance: Importance.max,
      playSound: true,
    );
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);

    final selectDate = await configureLocalTimeZone2(
      time.add(
        Duration(seconds: 5),
      ),
    );

    await fltrNotification.zonedSchedule(
      5,
      'Want Another Notification ?',
      'Click to Configure anther notification',
      selectDate,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: Text('EDIT/CREATE Notifications'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Radio(
                              value: '1',
                              groupValue: seletedButton,
                              onChanged: (s) {
                                setState(() {
                                  seletedButton = '1';
                                });
                              }),
                          Expanded(
                            child: Text('Notification 1'),
                          ),
                          Text(nameController1.text),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 5,
                      thickness: 4,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Radio(
                              value: '2',
                              groupValue: seletedButton,
                              onChanged: (s) {
                                setState(() {
                                  seletedButton = '2';
                                });
                              }),
                          Expanded(
                            child: Text('Notification 2'),
                          ),
                          Text(nameController2.text),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Create New Notification',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.only(left: 30, right: 20),
                              child: TextField(
                                controller: seletedButton == '1'
                                    ? nameController1
                                    : nameController2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Notifications Name',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    notificationName1 = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text('Input Notification Content'),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.only(left: 30, right: 20),
                              child: TextField(
                                controller: seletedButton == '1'
                                    ? contentController1
                                    : contentController2,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    notificationContent1 = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2021, 9, 9),
                                    onChanged: (date) {}, onConfirm: (date) {
                                  setState(() {
                                    if (seletedButton == '1') {
                                      selectedDate1 = date;
                                    } else {
                                      selectedDate2 = date;
                                    }
                                  });
                                },
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en);
                              },
                              child: Text(
                                'Select Time',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Selected Date:   ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(DateFormat('yyyy-MM-dd  ').format(
                                    seletedButton == '1'
                                        ? selectedDate1
                                        : selectedDate2)),
                                Text(DateFormat('jms').format(
                                    seletedButton == '1'
                                        ? selectedDate1
                                        : selectedDate2)),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  // _showNotification();
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Container(
                                            height: 100,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                      child: ListView(
                                                          shrinkWrap: true,
                                                          children: <Widget>[
                                                        ListTile(
                                                          title: Text('Shot'),
                                                          onTap: () {
                                                            setState(() {
                                                              if (seletedButton ==
                                                                  '1') {
                                                                selectedSound1 =
                                                                    'shot';
                                                              } else {
                                                                selectedSound2 =
                                                                    'shot';
                                                              }

                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                        ),
                                                        ListTile(
                                                          title: Text('Siren'),
                                                          onTap: () {
                                                            setState(() {
                                                              if (seletedButton ==
                                                                  '1') {
                                                                selectedSound1 =
                                                                    'siren';
                                                              } else {
                                                                selectedSound2 =
                                                                    'siren';
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          },
                                                        )
                                                      ]))
                                                ]),
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(Icons.cloud_upload_rounded),
                                label: Text('Select Sound')),
                            Row(
                              children: [
                                Text(
                                  ' SelectedSound :      ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(seletedButton == '1'
                                    ? selectedSound1
                                    : selectedSound2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {
                          if (seletedButton == '1') {
                            if (selectedDate1.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please select valid date')));
                              return;
                            }
                            if (selectedSound1 == 'shot') {
                              _showNotification2(nameController1.text,
                                  contentController1.text, 'shot');
                              _selectAgainNotification1(selectedDate1);
                            } else {
                              _showNotification1(nameController1.text,
                                  contentController1.text, 'shot');
                              _selectAgainNotification1(selectedDate1);
                            }
                          } else {
                            if (selectedDate2.isBefore(DateTime.now())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please select valid date')));
                              return;
                            }

                            if (selectedSound2 == 'shot') {
                              _showNotification2(nameController2.text,
                                  contentController2.text, 'shot');
                            } else {
                              _showNotification1(nameController2.text,
                                  contentController2.text, 'shot');
                            }
                          }

                          savingSharedPreferences();

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Notification Created ')));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Save/Edit Notification',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

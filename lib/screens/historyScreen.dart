import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final userId = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifications History'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('NotificationsHistory')
              .doc('HE9Oo0UpoWr2SgT9pXOr')
              .collection('users')
              .doc(userId)
              .collection('history')
              .orderBy(
                'time',
                descending: true,
              )
              .snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              return Center(
                child: Text('Error Occured'),
              );
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapShot.hasData) {
              final notificationHistory = snapShot.data.docs;

              return ListView.builder(
                  itemCount: notificationHistory.length,
                  itemBuilder: (context, index) {
                    var date = Timestamp.fromMillisecondsSinceEpoch(
                            notificationHistory[index]['time']
                                .millisecondsSinceEpoch)
                        .toDate();
                    print('$date----------------------------------------date');
                    return Card(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notification Name:   "${notificationHistory[index]['notificationName']}"',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Notification Content:   "${notificationHistory[index]['notificationContent']}"',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Notification Sound:  "${notificationHistory[index]['notificationSound']}"',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Created At:  "${DateFormat.yMd().add_jms().format(date)}"',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Container();
          },
        ));
  }
}

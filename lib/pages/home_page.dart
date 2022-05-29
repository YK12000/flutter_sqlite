import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sqlite/alarm.dart';
import 'package:flutter_sqlite/pages/add_edit_alarm_page.dart';
import 'package:flutter_sqlite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Alarm> alarmList = [];
  SlidableController controller = SlidableController();
  DateTime time = DateTime.now();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  Future<void> initDb() async {
    await DbProvider.setDb();
    alarmList = await DbProvider.getData();
    reBuild();
  }

  Future<void> reBuild() async {
    alarmList = await DbProvider.getData();
    setState(() {
      alarmList.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
    });
  }

  void initializeNotifications(){
    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('ic_launcher'),
            iOS: IOSInitializationSettings()
        ));
  }

  void setNotification(int id){
    flutterLocalNotificationsPlugin.zonedSchedule(
        id, 'アラーム', '時間になりました', tz.TZDateTime.now(tz.local).add(Duration(seconds: 3)),
        NotificationDetails(
        android: AndroidNotificationDetails('id','name',importance: Importance.max,priority: Priority.high),
        iOS: IOSNotificationDetails()
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );
  }

  void notification() async {
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: AndroidInitializationSettings('ic_launcher'),
          iOS: IOSInitializationSettings()
        ));
    flutterLocalNotificationsPlugin.show(1, 'アラーム', '時間になりました', NotificationDetails(
      android: AndroidNotificationDetails('id','name',importance: Importance.max,priority: Priority.high),
      iOS: IOSNotificationDetails()
    ));
  }


  @override
  void initState() {
    super.initState();
    initDb();
    initializeNotifications();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Colors.black,
            largeTitle: Text('アラーム',style: TextStyle(color: Colors.white)),
            trailing: GestureDetector(
                child: Icon(Icons.add,color: Colors.orange,),
                onTap: () async{
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAlarmPage(alarmList)));
                  setNotification(0);
                  reBuild();
                },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Alarm alarm = alarmList[index];
                return Column(
                  children: [
                    if(index == 0) Divider(color: Colors.grey,height: 2),
                    Slidable(
                      controller: controller,
                      actionPane: SlidableScrollActionPane(),
                      child: ListTile(
                        title: Text(DateFormat('H:mm').format(alarm.alarmTime),
                            style: TextStyle(color: Colors.white, fontSize: 50,
                            ),
                          ),
                          trailing: CupertinoSwitch(
                            value: alarm.isActive,
                            onChanged: (newvalue) async {
                              alarm.isActive = newvalue;
                              await DbProvider.updateData(alarm);
                              reBuild();
                            },
                          ),
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditAlarmPage(alarmList,index: index,)));
                          reBuild();
                        },
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          icon: Icons.delete,
                          caption: '削除',
                          color: Colors.red,
                          onTap: () async{
                            await DbProvider.deleteData(alarm.id);
                            reBuild();
                          },
                        )
                      ],
                    ),
                    Divider(color: Colors.grey,height: 0,)
                  ],
                );
              },
              childCount: alarmList.length)
          ),
        ],
      ),
    );
  }
}

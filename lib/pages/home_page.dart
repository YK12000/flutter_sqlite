import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sqlite/alarm.dart';
import 'package:flutter_sqlite/pages/add_edit_alarm_page.dart';
import 'package:flutter_sqlite/sqflite.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Alarm> alarmList = [];
  SlidableController controller = SlidableController();

  Future<void> initDb() async {
    await DbProvider.setDb();
    alarmList = await DbProvider.getData();
    setState(() {
    });
  }

  Future<void> reBuild() async {
    alarmList = await DbProvider.getData();
    setState(() {
      alarmList.sort((a, b) => a.alarmTime.compareTo(b.alarmTime));
    });
  }

  @override
  void initState() {
    super.initState();
    initDb();
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
                            onChanged: (newvalue) {
                              setState(() {
                                alarm.isActive = newvalue;
                              });
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
                          onTap: (){
                            alarmList.removeAt(index);
                            setState(() {
                            });
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

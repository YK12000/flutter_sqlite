import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_sqlite/alarm.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Alarm> alarmList = [
    Alarm(alarmTime: DateTime.now()),
    Alarm(alarmTime: DateTime.now()),
  ];

  SlidableController controller = SlidableController();

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
                onTap: (){

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
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          icon: Icons.delete,
                          caption: '削除',
                          color: Colors.red,
                          onTap: (){
                            
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

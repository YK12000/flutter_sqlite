import 'package:flutter/material.dart';

class AddeditAlarm extends StatefulWidget {
  const AddeditAlarm({Key? key}) : super(key: key);

  @override
  State<AddeditAlarm> createState() => _AddeditAlarmState();
}

class _AddeditAlarmState extends State<AddeditAlarm> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            child: Text('キャンセル',style: TextStyle(color: Colors.orange),),
          ),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.center,
              child: Text('保存',style: TextStyle(color: Colors.orange),),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          )
        ],
        backgroundColor: Colors.black87,
        title: Text('アラームの追加',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        height: double.infinity,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('時間',style: TextStyle(color: Colors.white),),
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none
                      ),
                      readOnly: true,
                      onTap: (){
                        
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

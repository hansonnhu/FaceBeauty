// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'guide.dart';
import 'register.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

String resultAllMsg = ""; //server 回傳的所有data，包含斷語。
String resultBasicMsg = ''; //簡要斷語String
List<String> title = []; //title : 臉型、下巴型、脣型......
List<String> textOfTitle = []; //title的內文
// List<String> temp1 = [];

class BasicResult extends StatefulWidget {
  const BasicResult({Key? key}) : super(key: key);

  @override
  _BasicResultState createState() => _BasicResultState();
}

class _BasicResultState extends State<BasicResult>
    with AutomaticKeepAliveClientMixin {
  bool firstGetResult_basic_flag = true;

  @override
  bool get wantKeepAlive => true;

  void _loadResultAllMsg() async {
    if (!firstGetResult_basic_flag) return;
    List<String> temp1 = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    resultAllMsg = (prefs.getString('resultAllMsg') ?? '');
    temp1 = resultAllMsg.split('&');
    // print(temp1.length);
    resultBasicMsg = temp1[0];
    List<String> temp2 = resultBasicMsg.split('[');

    //將server回傳的資料進行字串處理，得到title list 與 textOfTitle list
    int count = 0;
    for (String s in temp2) {
      if (count == 0) {
        title.insert(count, s.split('\n')[0]);
        textOfTitle.insert(count, s.split('\n')[1].replaceAll('#', ''));
        count++;
      } else {
        title.insert(count, s.split(']')[0]);
        textOfTitle.insert(count, s.split(']')[1].replaceAll('#', ''));
      }
    }
    // print(title[0]);
    // print(textOfTitle[0]);
    print(temp2);

    if (firstGetResult_basic_flag) {
      if (mounted) {
        firstGetResult_basic_flag = false;
        setState(() {});
      } else {
        Future.delayed(const Duration(milliseconds: 100), _loadResultAllMsg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    _loadResultAllMsg();

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //切割圖
                Expanded(flex: 1, child: Container()),

                //簡要內容
                Expanded(
                    flex: 1,
                    child: ListView.builder(
                        padding: new EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) => Container(
                                child: Column(
                              children: [
                                Container(
                                  width: screenWidth,
                                  child: Text(
                                    title[index].trim(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.yellow[300],
                                        fontSize: 25),
                                  ),
                                ),

                                Container(
                                  width: screenWidth,
                                  child: Text(
                                    textOfTitle[index].trim(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.white, 
                                        fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            )),
                        itemCount: title.length)),

                //繼續按鈕
              ],
            )));
  }
}

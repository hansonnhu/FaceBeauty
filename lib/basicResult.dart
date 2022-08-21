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
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

String imgLoadedFlag = 'NO';
String resultAllMsg = ''; //server 回傳的所有data，包含斷語。
String resultBasicMsg = ''; //簡要斷語String
List<String> oriImgStringList = []; //資料庫內所有原圖相片
String oriImgString = ''; //資料庫內最新的原圖相片
Uint8List basicImgByte = Uint8List(1000000);
// String basicImgString = '';

// File basicAndDetailImg = ;
List<int> pointX = []; //點x座標
List<int> pointY = []; //點y座標
List<String> basic_title = []; //basic_title : 臉型、下巴型、脣型......
List<String> basic_contentOfTitle = []; //basic_title的內文
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
    print('loading msg at basic');
    List<String> temp1 = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    resultAllMsg = (prefs.getString('resultAllMsg') ?? '');
    oriImgStringList = (prefs.getStringList('oriImgStringList') ?? []);
    oriImgString = oriImgStringList[oriImgStringList.length - 1];
    temp1 = resultAllMsg.split('&');
    // print(temp1.length);

    resultBasicMsg = temp1[0]; //簡要斷語

    for (int i = 0; i < 148; i++) {
      pointX.insert(i, int.parse(temp1[2].split('#')[i]));
      pointY.insert(i, int.parse(temp1[3].split('#')[i]));
    }

    /////////////////////////////////////////////////////////////// Drawing server //////////////////////////////////////////////////
    Socket socket = await Socket.connect('192.168.0.201', 6969);
    print('connected');

    // listen to the received data event stream

    String serverMsg = ''; //serverMsg
    await socket.listen((List<int> event) async {
      String temp = await utf8.decode(event);
      serverMsg = serverMsg + temp;
    });
    
    // print(serverMsg.split(';')[0]);

    String msg = oriImgString + '<' + temp1[2] + '<' + temp1[3] + ';';

    // send hello
    socket.add(utf8.encode(msg));

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 2));
      imgLoadedFlag = 'OK';//將 flag 設為OK，代表 img 已經 load 完成
      basicImgByte = base64Decode(serverMsg.split(';')[0]);

      // print(basicImgByte);
    // .. and close the socket
    socket.close();
    /////////////////////////////////////////////////////////////// server test//////////////////////////////////////////////////

    //
    List<String> temp2 = resultBasicMsg.split('[');

    //將server回傳的資料進行字串處理，得到basic_title list 與 basic_contentOfTitle list
    int count = 0;
    for (String s in temp2) {
      if (count == 0) {
        basic_title.insert(count, s.split('\n')[0]);
        basic_contentOfTitle.insert(
            count, s.split('\n')[1].replaceAll('#', ''));
        count++;
      } else {
        basic_title.insert(count, s.split(']')[0]);
        basic_contentOfTitle.insert(count, s.split(']')[1].replaceAll('#', ''));
      }
    }
    // print(basic_title[0]);
    // print(basic_contentOfTitle[0]);
    // print(temp2);

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
                Expanded(
                  
                    flex: 1,
                    child: 
                    (imgLoadedFlag == 'NO') ? Container():
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: 
                          Image.memory(
                            (basicImgByte),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ),

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
                                    basic_title[index].trim(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.yellow[300],
                                        fontSize: 25),
                                  ),
                                ),
                                Container(
                                  width: screenWidth,
                                  child: Text(
                                    basic_contentOfTitle[index].trim(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                              ],
                            )),
                        itemCount: basic_title.length)),

                //繼續按鈕
              ],
            )));
  }
}

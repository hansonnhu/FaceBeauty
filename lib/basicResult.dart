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

// flag部分
bool imgLoadedFlag = false;//是否已經下載圖片(已經下載後才能渲染頁面，不然會出錯)

//資料庫部分(基本上在這頁就會把所有資訊寫入資料庫，之後於其他頁面只要從資料庫讀去就好，不用再去連線server要資料)
String resultAllMsg = ''; //server 回傳的所有data，包含斷語。
List<String> oriImgStringList = []; //資料庫內所有原圖相片(每次拍照上傳後都會把圖片以String方式存在資料庫)
List<int> pointX = []; List<int> pointY = []; //點x,y座標(server會回傳100多個點)
String basicImgString = '';//全臉點圖String

//此頁面要用到之data
String resultBasicMsg = ''; //簡要斷語String
String oriImgString = ''; //資料庫內最新的原圖相片
Uint8List basicImgByte = Uint8List(1000000);//全臉點圖
List<String> basic_title = []; //basic_title : 臉型、下巴型、脣型......
List<String> basic_contentOfTitle = []; //basic_title的內文

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
    // List<String> temp1 = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    resultAllMsg = (prefs.getString('resultAllMsg') ?? '');
    oriImgStringList = (prefs.getStringList('oriImgStringList') ?? []);
    oriImgString = oriImgStringList[oriImgStringList.length - 1];
    // print(resultAllMsg.split('&').length);

    resultBasicMsg = resultAllMsg.split('&')[0]; //簡要斷語

    for (int i = 0; i < 148; i++) {
      pointX.insert(i, int.parse(resultAllMsg.split('&')[2].split('#')[i]));
      pointY.insert(i, int.parse(resultAllMsg.split('&')[3].split('#')[i]));
    }

    /////////////////////////////////////////////////////////////// Drawing server //////////////////////////////////////////////////
    ///將原圖片與所有點傳給 Drawing server 畫圖，畫完圖之後再傳回來
    Socket socket = await Socket.connect('192.168.0.201', 6969);
    print('connected');

    // listen to the received data event stream

    String serverMsg = ''; //serverMsg
    await socket.listen((List<int> event) async {
      String temp = await utf8.decode(event);
      serverMsg = serverMsg + temp;
    });
    
    // print(serverMsg.split(';')[0]);

    String msg = oriImgString + '<' + resultAllMsg.split('&')[2] + '<' + resultAllMsg.split('&')[3] + ';';

    // send hello
    socket.add(utf8.encode(msg));

    // wait 5 seconds
    await Future.delayed(Duration(seconds: 2));

    basicImgString = serverMsg.split(';')[0];//server回傳的第一張圖片String，即為全臉點圖
    prefs.setString('basicImgString', basicImgString);//將全臉點圖以String方式存入資料庫，提供其他頁面讀取使用
    basicImgByte = base64Decode(basicImgString);//將basicImgString轉成byte，才能渲染於頁面
    imgLoadedFlag = true;//將 flag 設為OK，代表 img 已經 load 完成


    // .. and close the socket
    socket.close();
    /////////////////////////////////////////////////////////////// server test//////////////////////////////////////////////////

    //
    List<String> temp = resultBasicMsg.split('[');

    //將server回傳的資料進行字串處理，得到basic_title list 與 basic_contentOfTitle list
    int count = 0;
    for (String s in temp) {
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
    // print(temp);

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
                    (imgLoadedFlag == false) ? Container():
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

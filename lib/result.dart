// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import "package:image_picker/image_picker.dart";
import 'basicResult.dart';
import 'detailResult.dart';
import 'package:shared_preferences/shared_preferences.dart';


//全域變數
//例項化選擇圖片
final ImagePicker picker = new ImagePicker();
//使用者本地圖片
// File _userImage;//存放獲取到的本地路徑

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    // double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: const TabBar(
              tabs: [
                Tab(text: '簡要'),
                Tab(text: '詳細'),
                Tab(text: '比例分析'),
              ],
            ),
            actions: <Widget>[
              Container(
                padding: const EdgeInsets.all(
                  8
                ),
                child: ElevatedButton(
                  child: Text('返回'),
                  style: ElevatedButton.styleFrom(
                      onSurface: Colors.white60,
                      primary: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal)),
                  onPressed: () async {
                    log('按下繼續按鈕');
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
          body: const TabBarView(
            children: [
              BasicResult(),
              DetailResult(),
              BasicResult(),
            ],
          ),
        ));
  }
}

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
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'proportionalAnalysis.dart';
import 'dart:typed_data';


//全域變數
//例項化選擇圖片
final ImagePicker picker = new ImagePicker();
var oriImgNum = 0;
//使用者本地圖片
// File _userImage;//存放獲取到的本地路徑

class Result extends StatefulWidget {
  const Result({Key? key,}) : super(key: key);
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {

  @override
  Widget build(BuildContext context) {

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

          ),
          body: const TabBarView(
            children: [
              BasicResult(),//  一開始會先跳到簡要斷語頁面，所以所有server data 之處理會在簡要段語頁面處理
              DetailResult(),
              PorportionalAnalysis(),
            ],
          ),
        ));
  }
}

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

String resultAllMsg = "";
String resultDetailMsg = '';
List<String> temp = [];
List<String> viewTextList = [];

class DetailResult extends StatefulWidget {
  const DetailResult({Key? key}) : super(key: key);

  @override
  _DetailResultState createState() => _DetailResultState();
}

class _DetailResultState extends State<DetailResult> with AutomaticKeepAliveClientMixin{
  bool firstGetResult_detail_flag = true;

  @override bool get wantKeepAlive => true;

  void _loadResultAllMsg() async {
    if (!firstGetResult_detail_flag) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    resultAllMsg = (prefs.getString('resultAllMsg') ?? '');
    temp = resultAllMsg.split('&');
    print(temp.length);
    resultDetailMsg = temp[1];
    viewTextList = resultDetailMsg.split('#[');
    // resultDetailMsg = resultDetailMsg.replaceAll(']', '\n');
    print(viewTextList[0]);

    if (firstGetResult_detail_flag) {
      if (mounted) {
        firstGetResult_detail_flag = false;
        setState(() {});
      } else {
        Future.delayed(const Duration(milliseconds: 100), _loadResultAllMsg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //初始化 firstGetResult_detail_flag 為true
    // bool firstGetResult_detail_flag = widget.firstGetResult_detail_flag;//初始化 firstGetResult_detail_flag 為true

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    // if(firstGetResult_detail_flag){
    //   _loadResultAllMsg();
    // }
    _loadResultAllMsg();
    // print(firstGetResult_detail_flag);

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(20),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //切割圖

                //簡要文字
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            resultDetailMsg,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ))),

                //繼續按鈕
              ],
            )));
  }
}

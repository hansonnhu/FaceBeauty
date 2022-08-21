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
// List<String> temp = [];
//detail文字架構
List<String> detail_title = []; //detail_title : 臉型、下巴型、脣型......
List<String> detail_contentOfTitle = []; //detail_title的內文

class DetailResult extends StatefulWidget {
  const DetailResult({Key? key}) : super(key: key);

  @override
  _DetailResultState createState() => _DetailResultState();
}

class _DetailResultState extends State<DetailResult>
    with AutomaticKeepAliveClientMixin {
  bool firstGetResult_detail_flag = true;

  @override
  bool get wantKeepAlive => true;

  void _loadResultAllMsg() async {
    if (!firstGetResult_detail_flag) return;
    print('loading msg at detail');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //server回傳之字串處理
    resultAllMsg = (prefs.getString('resultAllMsg') ?? '');
    resultDetailMsg = resultAllMsg.split('&')[1];
    // print(resultDetailMsg);
    List<String> temp1 = resultDetailMsg.split('[');

    //title
    int count = 0;
    for (String s in temp1) {
      if (s == '') continue;
      detail_title.insert(count, s.split(']')[0]);
      count++;
    }

    //title content
    count = 0;
    for (String s in temp1) {
      if (s == '') continue;
      detail_contentOfTitle.insert(count, s.split(']')[1].replaceAll('{', '').replaceAll('}', '').replaceAll('#', '\n\n'));
      count++;
    }

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
                              detail_title[index],
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.yellow[300], fontSize: 25),
                            ),
                          ),
                          Container(
                            width: screenWidth,
                            child: Text(
                              detail_contentOfTitle[index],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )),
                  itemCount: detail_title.length)),

          //繼續按鈕
        ],
      ),

      //繼續按鈕
    ));
  }
}

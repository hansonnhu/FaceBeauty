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

//flag
bool imgLoadedFlag = false;

//資料庫data
String resultAllMsg = ""; //server 回傳的所有data，包含斷語。
String proportionalImgString = ""; //比例分析全臉圖String

//此頁面要用到之data
Uint8List proportionalImgByte = Uint8List(1000000); //比例分析全臉圖byte
List<String> resultPorportionalMsgList = []; //
String faceComment = '';
String eyebrowComment = '';
String eyesComment = '';
String noseComment = '';
String mouthComment = '';
// List<String> temp = [];
//detail文字架構
List<String> detail_title = []; //detail_title : 臉型、下巴型、脣型......
List<String> detail_contentOfTitle = []; //detail_title的內文

class PorportionalAnalysis extends StatefulWidget {
  const PorportionalAnalysis({Key? key}) : super(key: key);

  @override
  _PorportionalAnalysisState createState() => _PorportionalAnalysisState();
}

class _PorportionalAnalysisState extends State<PorportionalAnalysis>
    with AutomaticKeepAliveClientMixin {
  bool firstGetResult_proportional_flag = true;

  @override
  bool get wantKeepAlive => true;

  void _loadResultAllMsg() async {
    if (!firstGetResult_proportional_flag) return;
    print('loading msg at proportional analysis');

    SharedPreferences prefs = await SharedPreferences.getInstance();

    //server回傳之字串處理
    resultAllMsg = (prefs.getString('resultAllMsg') ?? '');

    //server回傳data的邏輯非常奇怪
    //臉部分比例分析
    faceComment = resultAllMsg.split('&')[4].replaceAll('32:', '') +
        '\n' +
        resultAllMsg.split('&')[9].replaceAll('32:', '') +
        '\n' +
        resultAllMsg.split('&')[10].replaceAll('32:', '');

    //眉毛部分比例分析
    eyebrowComment = resultAllMsg.split('&')[5].replaceAll('2:', '');

    //眼睛部分比例分析
    eyesComment = resultAllMsg.split('&')[6].replaceAll('1:', '');

    //鼻子部分比例分析
    noseComment = resultAllMsg.split('&')[7].replaceAll('3:', '');

    //嘴巴部分比例分析
    mouthComment = resultAllMsg.split('&')[8].replaceAll('3:', '');

    //將data整合
    resultPorportionalMsgList = [
      faceComment,
      eyebrowComment,
      eyesComment,
      noseComment,
      mouthComment
    ];
    // for (int i = 4; i < 11; i++){
    //   resultPorportionalMsg += resultAllMsg.split('&')[i];
    //   resultPorportionalMsg += '\n';
    // }

    //擷取proportionalImgString
    proportionalImgString = prefs.getString('proportionalImgString') ?? '';
    proportionalImgByte = await base64Decode(
        proportionalImgString); //將proportionalImgString轉成byte，才能渲染於頁面
    imgLoadedFlag = true;

    if (firstGetResult_proportional_flag) {
      if (mounted) {
        firstGetResult_proportional_flag = false;
        setState(() {});
      } else {
        Future.delayed(const Duration(milliseconds: 100), _loadResultAllMsg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //初始化 firstGetResult_proportional_flag 為true
    // bool firstGetResult_proportional_flag = widget.firstGetResult_proportional_flag;//初始化 firstGetResult_proportional_flag 為true

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    // if(firstGetResult_proportional_flag){
    //   _loadResultAllMsg();
    // }
    _loadResultAllMsg();
    // print(firstGetResult_proportional_flag);

    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black87,
      width: screenWidth,
      height: screenHeight,

      child: Expanded(
        child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.yellow,
              height: 300,
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              color: Colors.blue,
              height: 300,
            ),
            //詳細內容
            Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: new EdgeInsets.only(top: 10, bottom: 10),
                itemCount: resultPorportionalMsgList.length,
                itemBuilder: (context, index) => Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(flex: 4, child: Container()),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: screenWidth,
                              child: Text(
                                resultPorportionalMsgList[index],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                ),
              )
            ),
          ],
        ),
      )),

      //繼續按鈕
    ));
  }
}

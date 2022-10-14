// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
// import 'dart:developer';
// import 'guide.dart';
// import 'register.dart';
// import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kg_charts/kg_charts.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

//flag

//資料庫data
List<String> resultAllMsg = []; //server 回傳的所有data，包含斷語。
String proportionalImgString = ""; //比例分析全臉圖String
List<String> allImgStrings = [];
//此頁面要用到之data
Uint8List proportionalImgByte = Uint8List(1000000); //比例分析全臉圖byte
// List<Uint8List> cropImgByteList = []; // 每個crop img 的byte
List<String> resultPorportionalMsgList = []; //每個部位之比例分析
String faceComment = '';
String eyebrowComment = '';
String eyesComment = '';
String noseComment = '';
String mouthComment = '';
String test = '';
List<double> radarValues = [0, 0, 0, 0, 0, 0];
// List<String> temp = [];
//detail文字架構


class PorportionalAnalysis extends StatefulWidget {
  const PorportionalAnalysis({Key? key}) : super(key: key);

  @override
  _PorportionalAnalysisState createState() => _PorportionalAnalysisState();
}

class _PorportionalAnalysisState extends State<PorportionalAnalysis>
    with AutomaticKeepAliveClientMixin {
  bool firstGetResult_proportional_flag = true;
  bool imgLoadedFlag = false;
  Uint8List cropBitmap_arrow_btye = Uint8List(10);
  Uint8List cropFace_sketch_btye = Uint8List(10);
  Uint8List cropFace_fake_btye = Uint8List(10);
  List<Uint8List> swiper_byte_list = [Uint8List(10)];
  List<Uint8List> cropImgByteList = []; //每個crop img 的byte
  String account = '';

  @override
  bool get wantKeepAlive => true;

  // 取得 雷達圖 的 score
  getScore(var min, var max, var value) {
    if (max == min) return 100;
    return 100 + (-100 / (max - min)) * (value - min).abs();
  }

  void _loadResultAllMsg() async {
    // 從資料庫中下載 ResultMag 並分割
    if (!firstGetResult_proportional_flag) return;
    print('loading msg at proportional analysis');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    account = prefs.getString('account') ?? '';

    //temp
    allImgStrings = prefs.getStringList(account+'oriImgStringList') ?? [];
    print('目前已上傳圖片數量');
    print(allImgStrings.length);

    print('imgLoadedFlag = ');
    print(imgLoadedFlag);

    //server回傳之字串處理
    resultAllMsg = (prefs.getStringList(account+'resultAllMsgList') ?? []);

    //從資料庫中取得 雷達圖 數據 ratio_2 、 ratio_11 、 ratio_23 、 ratio_28 、 ratio_30 、 ratio_15
    var oriImgIndex = prefs.getInt('oriImgIndex') ?? 0; // 取得當前 oriimg 之 index
    List<String> ratio_2_string = prefs.getStringList(account+'ratio_2') ?? [];
    List<String> ratio_11_string = prefs.getStringList(account+'ratio_11') ?? [];
    List<String> ratio_23_string = prefs.getStringList(account+'ratio_23') ?? [];
    List<String> ratio_28_string = prefs.getStringList(account+'ratio_28') ?? [];
    List<String> ratio_30_string = prefs.getStringList(account+'ratio_30') ?? [];
    List<String> ratio_15_string = prefs.getStringList(account+'ratio_15') ?? [];

    radarValues[0] = double.parse(ratio_2_string[oriImgIndex]);
    radarValues[1] = double.parse(ratio_11_string[oriImgIndex]);
    radarValues[2] = double.parse(ratio_23_string[oriImgIndex]);
    radarValues[3] = double.parse(ratio_28_string[oriImgIndex]);
    radarValues[4] = double.parse(ratio_30_string[oriImgIndex]);
    radarValues[5] = double.parse(ratio_15_string[oriImgIndex]);

    radarValues[0] = getScore(1.17, 2.0, radarValues[0]).toDouble();
    radarValues[1] = getScore(0.22, 0.5, radarValues[1]).toDouble();
    radarValues[2] = getScore(2.88, 4.5, radarValues[2]).toDouble();
    radarValues[3] = getScore(0.12, 0.5, radarValues[3]).toDouble();
    radarValues[4] = getScore(2.0, 10.0, radarValues[4]).toDouble();
    radarValues[5] = getScore(4.33, 10.0, radarValues[5]).toDouble();
    //

    //server回傳data的邏輯非常奇怪
    //臉部分比例分析
    faceComment = resultAllMsg[oriImgIndex].split('&')[4].replaceAll('32:', '').replaceAll('42:', '') +
        '\n' +
        resultAllMsg[oriImgIndex].split('&')[9].replaceAll('32:', '').replaceAll('42:', '') +
        '\n' +
        resultAllMsg[oriImgIndex].split('&')[10].replaceAll('32:', '').replaceAll('42:', '');

    //眉毛部分比例分析
    eyebrowComment = resultAllMsg[oriImgIndex].split('&')[5].replaceAll('2:', '');

    //眼睛部分比例分析
    eyesComment = resultAllMsg[oriImgIndex].split('&')[6].replaceAll('1:', '');

    //鼻子部分比例分析
    noseComment = resultAllMsg[oriImgIndex].split('&')[7].replaceAll('3:', '');

    //嘴巴部分比例分析
    mouthComment = resultAllMsg[oriImgIndex].split('&')[8].replaceAll('3:', '');

    //將data整合
    resultPorportionalMsgList = [
      faceComment,
      eyebrowComment,
      eyesComment,
      noseComment,
      mouthComment
    ];
    /////////////////////////////////////////////// 從資料庫中擷取crop imgs
    // bitmap 較小節圖 + 箭頭
    String tempString = prefs.getString('cropBitmap_arrow_string') ?? '';
    Uint8List tempByte = base64Decode(tempString);
    cropBitmap_arrow_btye = tempByte;

    // 臉型+素描
    tempString = prefs.getString('cropFace_sketch_string') ?? '';
    tempByte = base64Decode(tempString);
    cropFace_sketch_btye = tempByte;

    // 臉型+卡通(假圖)
    tempString = prefs.getString('cropFace_fake_string') ?? '';
    tempByte = base64Decode(tempString);
    cropFace_fake_btye = tempByte;

    swiper_byte_list = [
      cropBitmap_arrow_btye,
      cropFace_sketch_btye,
      cropFace_fake_btye
    ];

    // 臉型+箭頭
    tempString = prefs.getString('cropFace_arrow_string') ?? '';
    tempByte = base64Decode(tempString);
    cropImgByteList.insert(cropImgByteList.length, tempByte);

    // 眉毛
    tempString = prefs.getString('cropEyebrow_arrow_string') ?? '';
    tempByte = base64Decode(tempString);
    cropImgByteList.insert(cropImgByteList.length, tempByte);

    // 眼睛
    tempString = prefs.getString('cropEye_arrow_string') ?? '';
    tempByte = base64Decode(tempString);
    cropImgByteList.insert(cropImgByteList.length, tempByte);

    // 左右眼鼻子
    tempString = prefs.getString('cropEyesAndNose_arrow_string') ?? '';
    tempByte = base64Decode(tempString);
    cropImgByteList.insert(cropImgByteList.length, tempByte);

    // 嘴巴
    tempString = prefs.getString('cropMouth_arrow_string') ?? '';
    tempByte = await base64Decode(tempString);
    cropImgByteList.insert(cropImgByteList.length, tempByte);

    ///temp測試用
    // cropImgByteList.insert(cropImgByteList.length, tempByte);
    // cropImgByteList.insert(cropImgByteList.length, tempByte);
    ///temp測試用

    //////////////////////////////////////////////擷取proportionalImgString
    // proportionalImgString = prefs.getString('proportionalImgString') ?? '';
    // proportionalImgByte = await base64Decode(
    //     proportionalImgString); //將proportionalImgString轉成byte，才能渲染於頁面
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
      body: 
      (imgLoadedFlag == false)? Container():
      Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black87,
      width: screenWidth,
      height: screenHeight,

      child: Container(
          child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
          
           Container(
              height: screenHeight * 2 / 5,
              child: Swiper(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      swiper_byte_list[index],
                      fit: BoxFit.fitHeight,
                    ),
                  ));
                },
                pagination: const SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                  color: Colors.black54,
                  activeColor: Colors.white,
                )),
                // control: new SwiperControl(),
                scrollDirection: Axis.horizontal,
                autoplay: false,
                onTap: (index) => print('點選了第$index個'),
              )),
            Container(
              height: 25,
            ),

            Container(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: 
              
              RadarWidget(
                radarMap: RadarMapModel(
                  legend: [
                    LegendModel('test', Colors.yellow.shade800),
                  ],
                  indicator: [
                    IndicatorModel("臉", 100), //臉長/寬
                    IndicatorModel("額頭", 100), //額頭高度/臉長
                    IndicatorModel("眼", 100), //眼寬/眼高
                    IndicatorModel("人中", 100), //人中長度/臉寬
                    IndicatorModel("嘴唇", 100), //嘴唇寬度/臉寬
                    IndicatorModel("眉毛", 100), //眉毛寬度/高度
                  ],
                  data: [
                    MapDataModel(radarValues),
                  ],
                  radius: 80,
                  duration: 0,
                  shape: Shape.square,
                  maxWidth: 100,
                  line: LineModel(5),
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                isNeedDrawLegend: false,
              ),
            ),

            //詳細內容
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: new EdgeInsets.only(top: 10, bottom: 10),
              itemCount: resultPorportionalMsgList.length,
              itemBuilder: (context, index) => Container(
                  child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.memory(
                                      (cropImgByteList[index]),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )),
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
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              )),
            )
          ],
        ),
      )),

      //繼續按鈕
    ));
  }
}

// 簡要評語頁面
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'parameter.dart';

//資料庫部分(基本上在這頁就會把所有資訊寫入資料庫，之後於其他頁面只要從資料庫讀去就好，不用再去連線server要資料)
String resultAllMsg = ''; //server 回傳的所有data，包含斷語。
List<String> oriImgStringList = []; //資料庫內所有原圖相片(每次拍照上傳後都會把圖片以String方式存在資料庫)
List<int> pointX = [];
List<int> pointY = []; //點x,y座標(server會回傳148個點)
String cropFace_points_string = ''; //全臉點圖String

class BasicResult extends StatefulWidget {
  const BasicResult({Key? key}) : super(key: key);
  @override
  _BasicResultState createState() => _BasicResultState();
}

class _BasicResultState extends State<BasicResult>
    with AutomaticKeepAliveClientMixin {
  bool dataLoadedFlag = false; //是否已經下載圖片(已經下載後才能渲染頁面，不然會出錯)
  bool deepFakedataLoadedFlag = false;
  String account = '';
  //此頁面要用到之data
  String resultBasicMsg = ''; //簡要斷語String
  String oriImgString = ''; //資料庫內最新的原圖相片
  Uint8List basicImgByte = Uint8List(10); //全臉點圖
  Uint8List deepFakeImgByte = Uint8List(10); //deepFake gif
  List<String> allBasicTitle = []; //allBasicTitle : 臉型、下巴型、脣型......
  List<String> allBasicTextOfTitle = []; //allBasicTitle的內文

  @override
  bool get wantKeepAlive => true;
  //將回傳之gif寫入byte
  getDeepFakeImg() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    account = prefs.getString('account') ?? '';

    Socket socket = await Socket.connect(serverIP, serverPort);
    print('connected');

    // listen to the received data event stream
    List<int> intListServerMsg = [];
    // int returnImgCount = 0;
    await socket.listen((List<int> event) async {
      intListServerMsg.addAll(event); //server訊息不會一次傳完，須將每次存下來
    });

    // send hello
    var randomNum = Random().nextInt(100000);
    String tempClientNumString = account + ':' + randomNum.toString();
    String msg =
        'startCode103040023<' + tempClientNumString + '<' + 'imgDeepFake' + ';';
    List<int> msgBytes = [];
    msgBytes.addAll(utf8.encode(msg));
    msgBytes.add(0);

    socket.add(msgBytes);

    while (true) {
      await Future.delayed(Duration(milliseconds: 500));
      if (utf8.decode(intListServerMsg).contains(';')) {
        print('收到 deepfake img');
        String serverMsg = utf8.decode(intListServerMsg);
        String gif_string = serverMsg.split(';')[0];
        deepFakeImgByte = base64Decode(gif_string);

        // String msg = 'startCode103040023<'+tempClientNumString + '<' + 'disconnect' + ';';
        // List<int> msgBytes = [];
        // msgBytes.addAll(utf8.encode(msg));
        // msgBytes.add(0);
        // socket.add(msgBytes);
        await socket.close();
        break;
      }
    }
    deepFakedataLoadedFlag = true;
    try {
      setState(() {});
    } catch (e) {}
  }

  //將所有切割圖存入 SharedPreferences
  getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    allBasicTitle = prefs.getStringList('allBasicTitle') ?? [];
    allBasicTextOfTitle = prefs.getStringList('allBasicTextOfTitle') ?? [];

    dataLoadedFlag = true; //將 flag 設為OK，代表 img 已經 load 完成
    setState(() {});
  }

  // void _loadResultAllMsg() async {
  //   //////////////////////////////////////////// 解析所有server回傳之String，並且寫入前端資料庫
  //   if (!firstGetResult_basic_flag) return;
  //   print('loading msg at basic');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   account = await prefs.getString('account') ?? '';

  //   var oriImgIndex = prefs.getInt('oriImgIndex') ??
  //       0; //此為 oriImgString 的 index ，用於決定要分析資料庫中哪一張照片
  //   print('當前 oriImgIndex 為');
  //   print(oriImgIndex);

  //   List<String> tempList =
  //       (prefs.getStringList(account + 'resultAllMsgList') ?? []);
  //   resultAllMsg = tempList[oriImgIndex]; //取得該照片之 resultAllMsg

  //   oriImgStringList =
  //       (prefs.getStringList(account + 'oriImgStringList') ?? []);
  //   oriImgString = oriImgStringList[oriImgIndex]; //取得該照片

  //   resultBasicMsg = resultAllMsg.split('&')[0]; //[0]為簡要斷語內文
  //   List<String> temp = resultBasicMsg.split('[');

  //   //將server回傳的資料進行字串處理，得到allBasicTitle list 與 allBasicTextOfTitle list
  //   int count = 0;
  //   for (String s in temp) {
  //     if (count == 0) {
  //       allBasicTitle.insert(count, (s.split('\n')[0]).replaceAll('型', ''));
  //       allBasicTextOfTitle.insert(
  //           count, s.split('\n')[1].replaceAll('#', ''));
  //       count++;
  //     } else {
  //       allBasicTitle.insert(count, (s.split(']')[0]).replaceAll('型', ''));
  //       allBasicTextOfTitle.insert(count, s.split(']')[1].replaceAll('#', ''));
  //     }
  //   }

  //   //分割出148個點之座標
  //   String pointXString = resultAllMsg.split('&')[2]; //[2]為所有點之x座標
  //   String pointYString = resultAllMsg.split('&')[3]; //[3]為所有點之y座標

  //   //分割出34種比例，並且寫入資料庫
  //   String allRatioString = resultAllMsg.split('&')[11];
  //   List<String> allRatio = allRatioString.split('+');
  //   List<String> trendTitleList = [];

  //   int newImgDataFlag = prefs.getInt('newImgData?') ?? 0;
  //   if (newImgDataFlag == 1) {
  //     print('新增新的img，設定ratio');
  //     for (int i = 0; i < 34; i++) {
  //       //從 allRatio list中抓取ratio(數字部分)
  //       String ratio = allRatio[i];
  //       ratio = ratio.split(':')[1];
  //       ratio = ratio.replaceAll(' ', '').replaceAll(';', '');
  //       // print(ratio);
  //       String tempName = 'ratio_' + i.toString(); //ratio 序號，raiot_0 ~ ratio_33
  //       List<String> oneRatioString =
  //           await prefs.getStringList(account + tempName) ??
  //               []; // 先抓取資料庫裡的 list string
  //       oneRatioString.insert(
  //           oneRatioString.length, ratio); //將新的ratio insert 到此list
  //       await prefs.setStringList(account + tempName,
  //           oneRatioString); //再將新的 string list 更新至資料庫中(注意：若測試時只使用 result 頁面 debug時，必須註解此行，不然會一直增加前端資料庫)
  //       trendTitleList.insert(trendTitleList.length, allRatio[i].split(':')[0]);
  //     }
  //     await prefs.setStringList('trendTitleList', trendTitleList);
  //   } else {
  //     print('造訪舊的img');
  //   }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    // if (dataLoadedFlag == false) _loadResultAllMsg();
    if (dataLoadedFlag == false) {
      getAllData();
    }
    if (deepFakedataLoadedFlag == false && dataLoadedFlag == true) {
      getDeepFakeImg();
    }

    return WillPopScope(
      onWillPop: () async {
        print('點了返回');
        return true;
      },
      child: Scaffold(
          body: (dataLoadedFlag == false)
              ? Container(
                  color: Colors.black,
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: screenHeight / 8,
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  '繪製圖形中',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                          height: 50,
                          child: Image.asset(
                            'assets/laodingGIF.imageset/loading9.gif',
                            fit: BoxFit.fitHeight,
                          )),
                    ],
                  )

                  // Image.network('https://giphy.com/stickers/color-hybrid-hybridcolor-eWfqPa8CO0khmCNLA5'),
                  )
              : Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black,
                  width: screenWidth,
                  height: screenHeight,
                  child: Column(
                    children: [
                      //切割圖
                      Expanded(
                          flex: 1,
                          child: (deepFakedataLoadedFlag == false)
                              ? Container(
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                      ),
                                      child: AnimatedTextKit(
                                        repeatForever: true,
                                        isRepeatingAnimation: true,
                                        animatedTexts: [
                                          FadeAnimatedText(
                                            '繪製動畫中...',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.memory(
                                      (deepFakeImgByte),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                )),

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
                                            allBasicTitle[index].trim(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.yellow[300],
                                                fontSize: 25),
                                          )),
                                      Container(
                                        width: screenWidth,
                                        child: Text(
                                          allBasicTextOfTitle[index].trim(),
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  )),
                              itemCount: allBasicTitle.length)),
                    ],
                  ))),
    );
  }
}

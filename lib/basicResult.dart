// 簡要評語頁面
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';


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
  bool firstGetResult_basic_flag = true;
  bool imgLoadedFlag = false; //是否已經下載圖片(已經下載後才能渲染頁面，不然會出錯)
  String account = '';
  //此頁面要用到之data
  String resultBasicMsg = ''; //簡要斷語String
  String oriImgString = ''; //資料庫內最新的原圖相片
  Uint8List basicImgByte = Uint8List(1000000); //全臉點圖
  List<String> basic_title = []; //basic_title : 臉型、下巴型、脣型......
  List<String> basic_contentOfTitle = []; //basic_title的內文

  @override
  bool get wantKeepAlive => true;

  void _getAllPic(List<int> intListServerMsg)async {
    String serverMsg = ''; //serverMsg
    serverMsg = utf8.decode(intListServerMsg);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 儲存 Drawing server 回傳的所有圖片(臉型、比例圖、眉毛、眼睛...等等)
    //cropBitmap_arrow_string
    String cropBitmap_arrow_string = serverMsg.split(';')[1];
    prefs.setString('cropBitmap_arrow_string', cropBitmap_arrow_string);

    //cropFace_sketch_string
    String cropFace_sketch_string = serverMsg.split(';')[2];
    prefs.setString('cropFace_sketch_string', cropFace_sketch_string);

    //cropFace_fake_string
    String cropFace_fake_string = serverMsg.split(';')[3];
    prefs.setString('cropFace_fake_string', cropFace_fake_string);

    //cropFace_points_string
    cropFace_points_string = serverMsg.split(';')[0];
    prefs.setString('cropFace_points_string', cropFace_points_string);

    //cropFace_arrow_string
    String cropFace_arrow_string = serverMsg.split(';')[4];
    prefs.setString('cropFace_arrow_string', cropFace_arrow_string);

    //cropEyebrow_arrow_string
    String cropEyebrow_arrow_string = serverMsg.split(';')[5];
    prefs.setString('cropEyebrow_arrow_string', cropEyebrow_arrow_string);

    //cropEye_arrow_string
    String cropEye_arrow_string = serverMsg.split(';')[6];
    prefs.setString('cropEye_arrow_string', cropEye_arrow_string);

    //cropEyesAndNose_arrow_string
    String cropEyesAndNose_arrow_string = serverMsg.split(';')[7];
    prefs.setString(
        'cropEyesAndNose_arrow_string', cropEyesAndNose_arrow_string);

    //cropMouth_arrow_string
    String cropMouth_arrow_string = serverMsg.split(';')[8];
    prefs.setString('cropMouth_arrow_string', cropMouth_arrow_string);

    basicImgByte = base64Decode(cropFace_points_string); //將cropFace_points_string轉成byte，才能渲染於頁面
    imgLoadedFlag = true; //將 flag 設為OK，代表 img 已經 load 完成
    // firstGetResult_basic_flag = false;
    // setState(() {});
    if (firstGetResult_basic_flag) {
      if (mounted) {
        firstGetResult_basic_flag = false;
        setState(() {});
      } else {
        Future.delayed(const Duration(milliseconds: 100), _loadResultAllMsg);
      }
    }
  }

  void _loadResultAllMsg() async {
    //////////////////////////////////////////// 解析所有server回傳之String，並且寫入前端資料庫
    if (!firstGetResult_basic_flag) return;
    print('loading msg at basic');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    account = prefs.getString('account') ?? '';

    var oriImgIndex = prefs.getInt('oriImgIndex') ?? 0; //此為 oriImgString 的 index ，用於決定要分析資料庫中哪一張照片
    print('當前 oriImgIndex 為');
    print(oriImgIndex);

    List<String> tempList = (prefs.getStringList(account+'resultAllMsgList') ?? []);
    resultAllMsg = tempList[oriImgIndex]; //取得該照片之 resultAllMsg
    oriImgStringList = (prefs.getStringList(account+'oriImgStringList') ?? []);
    oriImgString = oriImgStringList[oriImgIndex]; //取得該照片

    resultBasicMsg = resultAllMsg.split('&')[0]; //[0]為簡要斷語內文
        List<String> temp = resultBasicMsg.split('[');

    //將server回傳的資料進行字串處理，得到basic_title list 與 basic_contentOfTitle list
    int count = 0;
    for (String s in temp) {
      if (count == 0) {
        basic_title.insert(count, (s.split('\n')[0]).replaceAll('型', ''));
        basic_contentOfTitle.insert(
            count, s.split('\n')[1].replaceAll('#', ''));
        count++;
      } else {
        basic_title.insert(count, (s.split(']')[0]).replaceAll('型', ''));
        basic_contentOfTitle.insert(count, s.split(']')[1].replaceAll('#', ''));
      }
    }

    //分割出148個點之座標
    String pointXString = resultAllMsg.split('&')[2]; //[2]為所有點之x座標
    String pointYString = resultAllMsg.split('&')[3]; //[3]為所有點之y座標

    //分割出34種比例，並且寫入資料庫
    String allRatioString = resultAllMsg.split('&')[11];
    List<String> allRatio = allRatioString.split('+');
    List<String> trendTitleList = [];

    int newImgDataFlag = prefs.getInt('newImgData?') ?? 0;
    if(newImgDataFlag == 1){
      print('新增新的img，設定ratio');
      for (int i = 0; i < 34; i++) {
        //從 allRatio list中抓取ratio(數字部分)
        String ratio = allRatio[i];
        ratio = ratio.split(':')[1];
        ratio = ratio.replaceAll(' ', '');
        // print(ratio);
        String tempName = 'ratio_' + i.toString(); //ratio 序號，raiot_0 ~ ratio_33
        List<String> oneRatioString = await prefs.getStringList(account+tempName) ?? []; // 先抓取資料庫裡的 list string
        oneRatioString.insert(oneRatioString.length, ratio); //將新的ratio insert 到此list
        prefs.setStringList(account+tempName,oneRatioString); //再將新的 string list 更新至資料庫中(注意：若測試時只使用 result 頁面 debug時，必須註解此行，不然會一直增加前端資料庫)
        trendTitleList.insert(trendTitleList.length,allRatio[i].split(':')[0]);
      }
      prefs.setStringList('trendTitleList', trendTitleList);
    }else{
      print('造訪舊的img');
    }
    

    /////////////////////////////////////////////////////////////// Drawing server //////////////////////////////////////////////////
    ///將原圖片與所有點傳給 Drawing server 畫圖，畫完圖之後再傳回來
    Socket makeImgServerSocket = await Socket.connect('192.168.0.201', 6969);
    // Socket makeImgServerSocket = await Socket.connect('140.117.168.12', 6969);
    print('connected');
    var randomNum = Random().nextInt(10000);
    String msg = account + randomNum.toString() + '<' +'imgDrawing'+ '<' + oriImgString + '<' + pointXString + '<' + pointYString + ';';
    // String msg = pointXString + '<' + pointYString + ';';

    // listen to the received data event stream
    List<int> intListServerMsg = [];
    // int returnImgCount = 0;
    await makeImgServerSocket.listen((List<int> event) async {
      intListServerMsg.addAll(event); //server訊息不會一次傳完，須將每次存下來
    });

    // send hello
      makeImgServerSocket.add(utf8.encode(msg));

    int secondCount = 0;
    int imgNumOffset = 0;
    while(true){
      int returnImgNum = await utf8.decode(intListServerMsg).split(';').length;
      if(imgNumOffset != returnImgNum){
        imgNumOffset = returnImgNum;
        print('已處理至圖片'+imgNumOffset.toString());
      }
      if(returnImgNum == 10){
          print('socket closed');
          await makeImgServerSocket.close();
          _getAllPic(intListServerMsg);
          
          return;
      }
      secondCount+=1;
      if(secondCount == 150){
        await makeImgServerSocket.close();
        // _getAllPic(intListServerMsg);
        return;
      }
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    _loadResultAllMsg();

    return Scaffold(
        body: (imgLoadedFlag == false)
            ? Container(
                color: Colors.black87,
                height: screenHeight,
                width: screenWidth,
                child: Center(
                  child: Container(
                      height: screenHeight / 4,
                      child: Image.asset(
                        'assets/laodingGIF.imageset/loading6.gif',
                        fit: BoxFit.fitHeight,
                      )),
                )

                // Image.network('https://giphy.com/stickers/color-hybrid-hybridcolor-eWfqPa8CO0khmCNLA5'),
                )
            : Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black87,
                width: screenWidth,
                height: screenHeight,
                child: Column(
                  children: [
                    //切割圖
                    Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.memory(
                              (basicImgByte),
                              fit: BoxFit.fill,
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
                                          basic_title[index].trim(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.yellow[300],
                                              fontSize: 25),
                                        )),
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

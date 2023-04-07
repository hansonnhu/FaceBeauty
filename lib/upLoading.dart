// app的一些設定調整(綁定硬體裝置)
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'result.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'parameter.dart';

class Uploading extends StatefulWidget {
  const Uploading({Key? key}) : super(key: key);

  @override
  _UploadingState createState() => _UploadingState();
}

class _UploadingState extends State<Uploading> {
  bool dataUploadFlag = false;
  String tempImgString = '';
  String account = '';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

  //將所有切割圖、allResult 存入 SharedPreferences
  getAllData(List<int> intListServerMsg) async {
    String serverMsg = ''; //serverMsg
    serverMsg = utf8.decode(intListServerMsg);
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //////////////////////////////////////////////  繪圖部分之圖片
    // 儲存 回傳的所有圖片(臉型、比例圖、眉毛、眼睛...等等)

    //cropFace_points_string
    String cropFace_points_string = serverMsg.split(';')[0];
    await prefs.setString('cropFace_points_string', cropFace_points_string);

    //cropBitmap_arrow_string
    String cropBitmap_arrow_string = serverMsg.split(';')[1];
    await prefs.setString('cropBitmap_arrow_string', cropBitmap_arrow_string);

    //cropFace_sketch_string
    String cropFace_sketch_string = serverMsg.split(';')[2];
    await prefs.setString('cropFace_sketch_string', cropFace_sketch_string);

    //cropFace_fake_string
    String cropFace_fake_string = serverMsg.split(';')[3];
    await prefs.setString('cropFace_fake_string', cropFace_fake_string);

    //cropFace_arrow_string
    String cropFace_arrow_string = serverMsg.split(';')[4];
    await prefs.setString('cropFace_arrow_string', cropFace_arrow_string);

    //cropEyebrow_arrow_string
    String cropEyebrow_arrow_string = serverMsg.split(';')[5];
    await prefs.setString('cropEyebrow_arrow_string', cropEyebrow_arrow_string);

    //cropEye_arrow_string
    String cropEye_arrow_string = serverMsg.split(';')[6];
    await prefs.setString('cropEye_arrow_string', cropEye_arrow_string);

    //cropEyesAndNose_arrow_string
    String cropEyesAndNose_arrow_string = serverMsg.split(';')[7];
    await prefs.setString(
        'cropEyesAndNose_arrow_string', cropEyesAndNose_arrow_string);

    //cropMouth_arrow_string
    String cropMouth_arrow_string = serverMsg.split(';')[8];
    await prefs.setString('cropMouth_arrow_string', cropMouth_arrow_string);

    //////////////////////////////////////////////  allResult部分(斷語)
    String allResult = serverMsg.split(';')[9];

    // 簡要斷語部分(titles 和 texts)
    String allBasicString = allResult.split('&')[0];
    List<String> allBasicTitle = [];
    List<String> allBasicTextOfTitle = [];

    // 簡要斷語title
    List<String> temp = allBasicString.split('#[');
    for(int i=0; i<temp.length; i++){
      if(temp[i] == '') continue;
      allBasicTitle.add(temp[i].split(']')[0]);
    }
    // 簡要斷語texts
    for(int i=0; i<temp.length; i++){
      if(temp[i] == '') continue;
      allBasicTextOfTitle.add(temp[i].split(']')[1]);
    }

    // 詳細斷語部分(titles 和 texts)
    String allDetailString = allResult.split('&')[1];
    List<String> allDetailTitle = [];
    List<String> allDetailTextOfTitle = [];
    allDetailString = allDetailString.replaceAll('#','');

    // 詳細斷語title
    temp = allDetailString.split('[');
    for(int i=0; i<temp.length; i++){
      if(temp[i] == '') continue;
      allDetailTitle.add(temp[i].split(']')[0]);
    }
    // 詳細斷語texts
    for(int i=0; i<temp.length; i++){
      if(temp[i] == '') continue;
      String s = temp[i];
      s = s.replaceAll('{', '\n\n');
      s = s.replaceAll('}', '\n');
      allDetailTextOfTitle.add(s.split(']')[1]);
    }
    
    await prefs.setStringList('allBasicTitle', allBasicTitle);
    await prefs.setStringList('allBasicTextOfTitle', allBasicTextOfTitle);
    await prefs.setStringList('allDetailTitle', allDetailTitle);
    await prefs.setStringList('allDetailTextOfTitle', allDetailTextOfTitle);


    //////////////////////////////////////////////  各種比例部分
    //分割出34種比例
    String allRatioString = allResult.split('&')[11];
    List<String> allRatio = allRatioString.split('+');
    // List<String> trendTitleList = [];

    for (int i = 0; i < 34; i++) {
        //從 allRatio list中抓取ratio(數字部分)
        String ratio = allRatio[i];
        ratio = ratio.split(':')[1];
        ratio = ratio.replaceAll(' ', '').replaceAll(';', '');
        // print(ratio);
        String tempName = 'ratio_' + i.toString(); //ratio 序號，raiot_0 ~ ratio_33
        await prefs.setString(tempName, ratio);
        // List<String> oneRatioString =
        //     await prefs.getStringList(account + tempName) ??
        //         []; // 先抓取資料庫裡的 list string
        // oneRatioString.insert(
        //     oneRatioString.length, ratio); //將新的ratio insert 到此list
        // await prefs.setStringList(account + tempName,
        //     oneRatioString); //再將新的 string list 更新至資料庫中(注意：若測試時只使用 result 頁面 debug時，必須註解此行，不然會一直增加前端資料庫)
        // trendTitleList.insert(trendTitleList.length, allRatio[i].split(':')[0]);
      }
      // await prefs.setStringList('trendTitleList', trendTitleList);


      //////////////////////////////////////////////  5種部位之比例分析
      //臉部分比例分析
      String faceComment = allResult.split('&')[4].split(':')[1] + '\n' +
          allResult.split('&')[9].split(':')[1] + '\n' +
          allResult.split('&')[10].split(':')[1];

      //眉毛部分比例分析
      String eyebrowComment = allResult.split('&')[5].split(':')[1];

      //眼睛部分比例分析
      String eyesComment = allResult.split('&')[6].split(':')[1];

      //鼻子部分比例分析
      String noseComment = allResult.split('&')[7].split(':')[1];

      //嘴巴部分比例分析
      String mouthComment = allResult.split('&')[8].split(':')[1];

      await prefs.setString('faceComment', faceComment);
      await prefs.setString('eyebrowComment', eyebrowComment);
      await prefs.setString('eyesComment', eyesComment);
      await prefs.setString('noseComment', noseComment);
      await prefs.setString('mouthComment', mouthComment);
  }



    //於資料庫抓取 tempImgString並且上傳
    uploadImg() async {
      print('第一次進 Uploading !');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      tempImgString = prefs.getString('tempImgString')??'';
      account = prefs.getString('account')??'';
      String imgIsFromHistory = prefs.getString('imgFromHistory')??'false';

      ////////////////////////////////////////////// 將tempImg原圖上傳，若分析成功，則將tempImg寫入資料庫
      Socket socket = await Socket.connect(serverIP, serverPort);
      // Socket socket = await Socket.connect('140.117.168.12', serverPort);
      print('connected');
      
      
      List<int> intListServerMsg = [];
      socket.listen((List<int> event) async {
        intListServerMsg.addAll(event); //server訊息不會一次傳完，須將每次存下來
      });

      // 傳送訊息給server
      var randomNum = Random().nextInt(100000);
      String tempClientNumString = account + ':' + randomNum.toString();
      String msg = '';
      if(imgIsFromHistory == 'false'){// 新圖片傳給server
        msg = 'startCode103040023<' + tempClientNumString + '<' + 'imgAnalysis' + '<' + tempImgString + '<' + 'newImg' + ';';
      }else if(imgIsFromHistory == 'true'){// 歷史紀錄之圖片傳給server
        msg = 'startCode103040023<' + tempClientNumString + '<' + 'imgAnalysis' + '<' + tempImgString + '<' + 'historyImg' + ';';
      }
      
      List<int> msgBytes = [];
      msgBytes.addAll(utf8.encode(msg));
      msgBytes.add(0);
      socket.add(msgBytes);


      int secondCount = 0;
      int imgNumOffset = 0;
      while (true) {
        await Future.delayed(Duration(milliseconds: 500));
        int returnDataNum = utf8.decode(intListServerMsg).split(';').length;
        if (utf8.decode(intListServerMsg).contains('error')){
          print('未偵測到人臉');

          // 要求server斷線
          // String msg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
          // List<int> msgBytes = [];
          // msgBytes.addAll(utf8.encode(msg));
          // msgBytes.add(0);
          // socket.add(msgBytes);
          socket.close();

          //AlertDialog
          try {
            Navigator.pop(context);
          } catch (e) {

          }
          
          BuildContext dialogContext = context;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                dialogContext = context;
                return const AlertDialog(
                  title: Text('未偵測到人臉'),
                  content: Text('請重新拍照或上傳'),
                );
              });
          break;
        }
        if (imgNumOffset != returnDataNum) {
          imgNumOffset = returnDataNum;
          print('已處理至data ' + imgNumOffset.toString());
        }

        if (returnDataNum == 12) {
          await getAllData(intListServerMsg);
          
          // 要求斷線
          // String msg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
          // List<int> msgBytes = [];
          // msgBytes.addAll(utf8.encode(msg));
          // msgBytes.add(0);
          // socket.add(msgBytes);
          socket.close();

          dataUploadFlag = true;
          print('分析完成');

          try {
            Navigator.pop(context);
            if(imgIsFromHistory=='false'){// 再多pop 一次
              Navigator.pop(context);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Result(),
                maintainState: false,
              ),
          );
          } catch (e) {

          }
          // setState(() {});
        }

        

        // 若繪圖失敗，則斷線
        // secondCount += 1;
        // if (secondCount == 20 && returnDataNum < 10) {
        //   String msg = tempClientNumString + '<' + 'disconnect' + ';';
        //   List<int> msgBytes = [];
        //   msgBytes.addAll(utf8.encode(msg));
        //   msgBytes.add(0);
        //   socket.add(msgBytes);
        //   await socket.close();

        //   //AlertDialog
        //   Navigator.pop(context);
        //   BuildContext dialogContext = context;
        //   showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         dialogContext = context;
        //         return const AlertDialog(
        //           title: Text('此相片繪圖時發生問題'),
        //           content: Text('請換其他張圖測試'),
        //         );
        //       });
        //   break;
        // }
      }

    }
    if(dataUploadFlag == false){
      print('上傳影像分析中');
      uploadImg();
    }
    
      

    return Scaffold(
        body: Container(
          color: Colors.black,
          child:
            Center(
              child: DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      animatedTexts: [
                        FadeAnimatedText(
                          '分析中' ,
                        ),
                      ],
                    ),
                  ),
            ),
      )
    );
  }
}

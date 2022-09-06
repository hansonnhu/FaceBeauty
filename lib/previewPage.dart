//相機拍照完的preview
import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
// import 'package:bitmap/bitmap.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'result.dart';
import 'dart:async';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

// String serverMsg = ''; 
String account = "";
bool firstModifyFlag = true;
bool imgUploadOK = true;
var oriImgNum = 0;

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);
  

  final XFile picture;
  
  @override
  Widget build(BuildContext context) {
    
    // 抓取UserInfo
    _loadUserInfo() async {
      log('loading user info');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = (prefs.getString('account') ?? '');
      firstModifyFlag = false;
    }

    if (firstModifyFlag) {
      _loadUserInfo();
    }

    //將照片上傳
    _uploadImg(File oriImg) async {
      
      String serverMsg = "";
      String oriImgString = "";
      String smallImgString = "";
      print('帳號為 : ' + account);
      
      makeImg()async {
        var decodedImage = await decodeImageFromList(oriImg.readAsBytesSync());
        double scale = 0;
        //將原圖長邊縮小為80，短編等比例縮小
        if (decodedImage.width > decodedImage.height) {
          scale = 80 / decodedImage.width;
        } else {
          scale = 80 / decodedImage.height;
        }
        //縮小圖
        File smallImg = await FlutterNativeImage.compressImage(oriImg.path,
            targetWidth: (scale * decodedImage.width).round(),
            targetHeight: (scale * decodedImage.height).round());

        //獲取原圖及小圖的bytes
        Uint8List oriImgBytes = await oriImg.readAsBytes();
        Uint8List smallImgBytes = await smallImg.readAsBytes();
        oriImgString = base64Encode(oriImgBytes);
        smallImgString = base64Encode(smallImgBytes);
      }
      
      await makeImg();

      /////////////////////////////////////////////////////////////////傳給server////////////////////////////////////////////////
      
      Socket socket = await Socket.connect('140.117.168.12', 50886);
      print('connected');

      String msg =  (account + "<" + oriImgString + "<" + smallImgString + ";");
      List<int> sendMsg = utf8.encode(msg);

      // send hello
      socket.add(sendMsg);

      // listen to the received data event stream
      List<int> intListServerMsg = [];
      socket.listen((List<int> event) async {
          intListServerMsg.addAll(event);//server訊息不會一次傳完，須將每次存下來
        }
      );

      // wait 10 seconds
      await Future.delayed(const Duration(seconds: 12));
      serverMsg = utf8.decode(intListServerMsg);//將 intListServerMsg 解碼為 String
      // .. and close the socket
      socket.close();

      print('server長度');
      print(serverMsg.split('&').length);
      // print('data = ' + serverMsg);
      // 若回傳data不正確(有漏)，請使用者重新拍照
      if (serverMsg.split('&').length != 14) {
        print('失敗');
        imgUploadOK = false;
        return;
      }else{
        imgUploadOK = true;
      }
      

      SharedPreferences prefs = await SharedPreferences.getInstance(); //讀取資料庫
      List<String> oriImgStringList = prefs.getStringList('oriImgStringList') ?? []; //讀取資料庫內過往所有oriImgString List(因為每拍一張就會存在資料庫)
      oriImgNum = oriImgStringList.length;  //取得當前 oriImg 之 index(由於是拍照或選擇照片上傳，因此為最新的一張 oriImg)
      prefs.setInt('oriImgIndex', oriImgNum);//將oriImg 之 index 存入資料庫
      //將最新拍的 oriImgString insert 到資料庫中 oriImgString List
      oriImgStringList.insert(oriImgStringList.length, oriImgString);
      await prefs.setStringList('oriImgStringList', oriImgStringList);
      
      // 將最新的 datetime 更新至資料庫中
      List<String> allDateTimeList = prefs.getStringList('allDateTimeList') ?? [];
      DateTime dateTime = DateTime.now();
      allDateTimeList.insert(allDateTimeList.length, dateTime.toString().substring(0,19));
      await prefs.setStringList('allDateTimeList', allDateTimeList);
      



      //////////////////////測試//////////////////
      // List<String> temp = [oriImgString];
      // await prefs.setStringList('oriImgStringList', temp);
      ///////////////////////////////////////////

      //將此次resultAllMsg更新至資料庫()
      List<String> temp = prefs.getStringList('resultAllMsgList') ?? [];
      temp.insert(temp.length, serverMsg);
      await prefs.setStringList('resultAllMsgList', temp);
      /////////////////////////////////////////////////////////////////傳給舊server////////////////////////////////////////////////
    }

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    return Scaffold(
      body: Center(
          child: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black87,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Expanded(
              flex: 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.file(File(picture.path),
                            fit: BoxFit.cover, width: screenWidth - 20),
                      )
                    ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: 
                    ClipRRect(
                      child:Image.asset('assets/face_3.imageset/face_3@3x.png',
                      fit: BoxFit.cover,
                      width: screenWidth -12), 
                    )
                    
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      child: Text('送出'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                      onPressed: () async {
                        log('按下送出按鈕');
                        var oriImg = File(picture.path); //原圖

                        //AlertDialog
                        BuildContext dialogContext = context; 
                        showDialog(
                          context: context,
                          builder: (BuildContext context) { 
                            dialogContext = context;
                            return AlertDialog(
                            title: Text('上傳成功!'),
                            content: Text('分析中......'),
                          );}
                        );

                        //上傳至server
                        await _uploadImg(oriImg);

                        if (imgUploadOK == true) {
                          Navigator.pop(dialogContext);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Result(),
                              maintainState: false,
                            ),
                          );
                        } else {
                          Navigator.pop(dialogContext);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('上傳失敗!'),
                              content: const Text('位置不正確，請重新拍照!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text('重拍'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                      onPressed: () {
                        log('按下重拍按鈕');
                        Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => const Home(),
                        //           maintainState: false,
                        //         ),
                        //       );
                        
                        // log('account: ${account.text}');
                        // log('password: ${password.text}');
                      },
                    ),
                  ]))
        ]),
      )),
    );
  }
}

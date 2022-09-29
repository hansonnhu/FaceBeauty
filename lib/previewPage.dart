//相機拍照完的preview

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
import 'package:image/image.dart' as _img;
// import 'package:image/image.dart';

// String serverMsg = '';
String account = "";
bool firstModifyFlag = true;
bool imgUploadOK = false;
var oriImgNum = 0;


class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture, required this.type, required this.cameraNum}) : super(key: key);

  final XFile picture;
  final String type;
  final int cameraNum;



  @override
  Widget build(BuildContext context) {
    String bigImgString = '';
    String smallImgString = '';
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
    _processingMsg(List<int> intListServerMsg, String oriImgString)async {
      String serverMsg = utf8.decode(intListServerMsg); //將 intListServerMsg 解碼為 String

      print('server長度');
      print(serverMsg.split('&').length);
      // print('data = ' + serverMsg);
      // 若回傳data不正確(有漏)，請使用者重新拍照
      if (serverMsg.split('&').length != 14) {
        print('失敗');
        imgUploadOK = false;
        return;
      } else {
        imgUploadOK = true;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance(); //讀取資料庫
      await prefs.setInt('newImgData?', 1);
      List<String> oriImgStringList = prefs.getStringList(account + 'oriImgStringList') ??
          []; //讀取資料庫內過往所有oriImgString List(因為每拍一張就會存在資料庫)
      oriImgNum = oriImgStringList
          .length; //取得當前 oriImg 之 index(由於是拍照或選擇照片上傳，因此為最新的一張 oriImg)
      prefs.setInt('oriImgIndex', oriImgNum); //將oriImg 之 index 存入資料庫
      //將最新拍的 oriImgString insert 到資料庫中 oriImgString List
      oriImgStringList.insert(oriImgStringList.length, oriImgString);
      await prefs.setStringList(account+'oriImgStringList', oriImgStringList);

      // 將最新的 datetime 更新至資料庫中
      List<String> allDateTimeList =
          prefs.getStringList(account+'allDateTimeList') ?? [];
      DateTime dateTime = DateTime.now();
      allDateTimeList.insert(
          allDateTimeList.length, dateTime.toString().substring(0, 19));
      await prefs.setStringList(account+'allDateTimeList', allDateTimeList);

      //將此次resultAllMsg更新至資料庫()
      List<String> temp = prefs.getStringList(account+'resultAllMsgList') ?? [];
      temp.insert(temp.length, serverMsg);
      await prefs.setStringList(account+'resultAllMsgList', temp);
      
    }

    //將照片上傳
    _uploadImg(File oriImg) async {
      // if (imgUploadOK) return;
      String serverMsg = "";
      String oriImgString = "";
      String smallImgString = "";
      print('帳號為 : ' + account);

      makeImg() async {
        var _decodedImage = await decodeImageFromList(oriImg.readAsBytesSync());
        if(_decodedImage.height > 1000 && _decodedImage.width > 1000){//若原圖太大，將其縮小
          double resizeRate = 0.0;
          if(_decodedImage.height >= _decodedImage.width){
            resizeRate = _decodedImage.height/1000;
          }else{
            resizeRate = _decodedImage.width/1000;
          }
          if(type == 'camera'){
            oriImg = await FlutterNativeImage.compressImage(oriImg.path,
            targetHeight: (_decodedImage.width / resizeRate).round(),
            targetWidth: (_decodedImage.height / resizeRate).round());
          }else{
            oriImg = await FlutterNativeImage.compressImage(oriImg.path,
            targetWidth: (_decodedImage.width / resizeRate).round(),
            targetHeight: (_decodedImage.height / resizeRate).round());
          }
          
          // _decodedImage = await decodeImageFromList(oriImg.readAsBytesSync());
        }
        
        
        // double scale = 0;
        // //將原圖長邊縮小為80，短編等比例縮小
        // if (_decodedImage.width > _decodedImage.height) {
        //   scale = 80 / _decodedImage.width;
        // } else {
        //   scale = 80 / _decodedImage.height;
        // }
        // //縮小圖
        // File smallImg = oriImg;
        // if(type == 'camera'){
        //   smallImg = await FlutterNativeImage.compressImage(oriImg.path,
        //   targetHeight: (scale * _decodedImage.width).round(),
        //   targetWidth: (scale * _decodedImage.height).round());
        // }else{
        //   smallImg = await FlutterNativeImage.compressImage(oriImg.path,
        //   targetHeight: (scale * _decodedImage.width).round(),
        //   targetWidth: (scale * _decodedImage.height).round());
        // }
        //獲取原圖及小圖的bytes
        Uint8List oriImgBytes = await oriImg.readAsBytes();
        oriImgString = base64Encode(oriImgBytes);

        // Uint8List smallImgBytes = await smallImg.readAsBytes();
        // smallImgString = base64Encode(smallImgBytes);
        

        print('camera img');
        // Socket socket = await Socket.connect('192.168.0.201', 6969);
        Socket socket = await Socket.connect('140.117.168.12', 6969);
        print('connected');

        // String msg = (oriImgString + '<' + type + '<' + cameraNum.toString() + '<' + "?");
        String msg = (oriImgString + '<' + "?");
        List<int> sendMsg = utf8.encode(msg);

        // send hello
        socket.add(sendMsg);

        // listen to the received data event stream
        
        List<int> intListServerMsg = [];
        socket.listen((List<int> event) async {
          intListServerMsg.addAll(event); //server訊息不會一次傳完，須將每次存下來
        });
        int serverCount = 0;
        while(true){
          if(utf8.decode(intListServerMsg).contains(';')){
            print(';的啦');
            await socket.close();
            // await _processingMsg(intListServerMsg, oriImgString);
            break;
          }
          
          else {
            await Future.delayed(const Duration(seconds: 1));
            serverCount += 1;
            if(serverCount == 5){
              await socket.close();
              break;
            }
          }
        }
        String tempMsg = utf8.decode(intListServerMsg);
        oriImgString = tempMsg.split(';')[0].split('>')[0];
        smallImgString = tempMsg.split(';')[0].split('>')[1];
      }

      await makeImg();

      /////////////////////////////////////////////////////////////////傳給server////////////////////////////////////////////////

      Socket socket = await Socket.connect('140.117.168.12', 50886);
      print('connected');

      String msg = (account + "<" + oriImgString + "<" + smallImgString + ";");
      // String msg = (account + "<" + bigImgString + "<" + smallImgString + ";");
      List<int> sendMsg = utf8.encode(msg);

      // send hello
      socket.add(sendMsg);

      // listen to the received data event stream
      
      List<int> intListServerMsg = [];
      socket.listen((List<int> event) async {
        intListServerMsg.addAll(event); //server訊息不會一次傳完，須將每次存下來

      });
      int serverCount = 0;
      while(true){
        print(utf8.decode(intListServerMsg));
        if(utf8.decode(intListServerMsg).contains(';')){
          print(';的啦');
          await socket.close();
          await _processingMsg(intListServerMsg, oriImgString);
          return;
        }
        
        else {
          await Future.delayed(const Duration(seconds: 1));
          serverCount += 1;
          if(serverCount == 20){
            await socket.close();
            return;
          }
        }
          
      }
      // wait 15 seconds
      await Future.delayed(const Duration(seconds: 15));
      // .. and close the socket
      socket.close();
      // serverMsg = utf8.decode(intListServerMsg); //將 intListServerMsg 解碼為 String
      
      // print('server長度');
      // print(serverMsg.split('&').length);
      // // print('data = ' + serverMsg);
      // // 若回傳data不正確(有漏)，請使用者重新拍照
      // if (serverMsg.split('&').length != 14) {
      //   print('失敗');
      //   imgUploadOK = false;
      //   return;
      // } else {
      //   imgUploadOK = true;
      // }

      // SharedPreferences prefs = await SharedPreferences.getInstance(); //讀取資料庫
      // await prefs.setInt('newImgData?', 1);
      // List<String> oriImgStringList = prefs.getStringList(account + 'oriImgStringList') ??
      //     []; //讀取資料庫內過往所有oriImgString List(因為每拍一張就會存在資料庫)
      // oriImgNum = oriImgStringList
      //     .length; //取得當前 oriImg 之 index(由於是拍照或選擇照片上傳，因此為最新的一張 oriImg)
      // prefs.setInt('oriImgIndex', oriImgNum); //將oriImg 之 index 存入資料庫
      // //將最新拍的 oriImgString insert 到資料庫中 oriImgString List
      // oriImgStringList.insert(oriImgStringList.length, oriImgString);
      // await prefs.setStringList(account+'oriImgStringList', oriImgStringList);

      // // 將最新的 datetime 更新至資料庫中
      // List<String> allDateTimeList =
      //     prefs.getStringList(account+'allDateTimeList') ?? [];
      // DateTime dateTime = DateTime.now();
      // allDateTimeList.insert(
      //     allDateTimeList.length, dateTime.toString().substring(0, 19));
      // await prefs.setStringList(account+'allDateTimeList', allDateTimeList);

      // //////////////////////測試//////////////////
      // // List<String> temp = [oriImgString];
      // // await prefs.setStringList('oriImgStringList', temp);
      // ///////////////////////////////////////////

      // //將此次resultAllMsg更新至資料庫()
      // List<String> temp = prefs.getStringList(account+'resultAllMsgList') ?? [];
      // temp.insert(temp.length, serverMsg);
      // await prefs.setStringList(account+'resultAllMsgList', temp);
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
                      )),
                  Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        child: Image.asset(
                            'assets/face_3.imageset/face_3@3x.png',
                            fit: BoxFit.cover,
                            width: screenWidth - 12),
                      ))
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
                              return Center(
                                child: Container(
                                  // color: Colors.white,
                                  child: Image.asset(
                                    "assets/laodingGIF.imageset/loading6.gif",
                                    height: screenHeight,
                                  ),
                                ),
                              );
                            });

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
                      },
                    ),
                  ]))
        ]),
      )),
    );
  }
}

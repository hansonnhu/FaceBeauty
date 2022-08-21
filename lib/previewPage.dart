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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

String account = "";
bool firstModifyFlag = true;

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
      print('帳號為 : '+account);
      //將原圖長邊縮小為80，短編等比例縮小
      var decodedImage = await decodeImageFromList(oriImg.readAsBytesSync());
      double scale = 0;
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
      String oriImgString = base64Encode(oriImgBytes);

      String smallImgString = base64Encode(smallImgBytes);


      /////////////////////////////////////////////////////////////////傳給舊server////////////////////////////////////////////////
      Socket socket = await Socket.connect('140.117.168.12', 50886);
      print('connected');

      // listen to the received data event stream
      
      String serverMsg = '';  //serverMsg
      socket.listen((List<int> event) async {
        String temp = utf8.decode(event);
        serverMsg = serverMsg+temp; 
      });
      

      String msg = account + "<" + oriImgString + "<" + smallImgString + ";";

      // send hello
      socket.add(utf8.encode(msg));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 10));

      // .. and close the socket
      socket.close();
      print('data = '+serverMsg);
      SharedPreferences prefs = await SharedPreferences.getInstance();  //讀取本機資料庫
      List<String> oriImgStringList = prefs.getStringList('oriImgStringList') ?? [];
      oriImgStringList.insert(oriImgStringList.length, oriImgString);
      await prefs.setStringList('oriImgStringList', oriImgStringList);
      await prefs.setString('resultAllMsg', serverMsg);
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
              child: Container(
                  padding: const EdgeInsets.only(top: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(File(picture.path),
                        fit: BoxFit.cover, width: screenWidth - 20),
                  ))),
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


                        // //將原圖長邊縮小為80，短編等比例縮小
                        // var decodedImage =
                        //     await decodeImageFromList(oriImg.readAsBytesSync());
                        // double scale = 0;
                        // if (decodedImage.width > decodedImage.height) {
                        //   scale = 80 / decodedImage.width;
                        // } else {
                        //   scale = 80 / decodedImage.height;
                        // }
                        // File smallImg = await FlutterNativeImage.compressImage(
                        //     oriImg.path,
                        //     targetWidth: (scale * decodedImage.width).round(),
                        //     targetHeight:
                        //         (scale * decodedImage.height).round());

                        // //獲取原圖及小圖的byte
                        // Uint8List oriImgBytes = await oriImg.readAsBytes();
                        // Uint8List smallImgBytes = await smallImg.readAsBytes();
                        // String oriImgString = base64Encode(oriImgBytes);
                        // String smallImgString = base64Encode(smallImgBytes);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => const AlertDialog(
                            title: Text('上傳成功!'),
                            content: Text('分析中......'),
                          ),
                        );

                        //上傳至server
                        await _uploadImg(oriImg);

                        Navigator.pop(context);
                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Result(),
                            maintainState: false,
                          ),
                        );
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

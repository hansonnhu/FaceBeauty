//相機拍照完的preview
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
// import 'package:bitmap/bitmap.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

String account = "";
bool firstModifyFlag = true;

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;
  @override
  Widget build(BuildContext context) {
    _loadUserInfo() async {// 抓取UserInfo
      log('loading user info');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = (prefs.getString('account') ?? '');
      firstModifyFlag = false;
    }
    if (firstModifyFlag) {
      _loadUserInfo();
    }
    _uploadImg(String oriImgBytes, String smallImgBytes) async {
      Uint8List bytes = await File(picture.path).readAsBytes();
      Socket socket = await Socket.connect('140.117.168.12', 50886);
      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {

        print(utf8.decode(event));
      });

      String msg = account + "<" + oriImgBytes + "<" + smallImgBytes + ";";

      // send hello
      socket.add(utf8.encode(msg));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 10));

      // .. and close the socket
      socket.close();
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
                    children:[
                      ElevatedButton(
                        child: Text('送出'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal)),
                        onPressed: () async{
                          log('按下送出按鈕');
                          var oriImg = new File(picture.path);  //原圖

                          //將原圖長邊縮小為80，短編等比例縮小
                          var decodedImage = await decodeImageFromList(oriImg.readAsBytesSync());
                          double scale = 0;
                          if(decodedImage.width>decodedImage.height){
                            scale = 80/decodedImage.width;
                          }
                          else{
                            scale = 80/decodedImage.height;
                          }
                          File smallImg = await FlutterNativeImage.compressImage(oriImg.path,
                          targetWidth:(scale*decodedImage.width).round(),
                          targetHeight:(scale*decodedImage.height).round());

                          //獲取原圖及小圖的byte
                          Uint8List oriImgBytes = await oriImg.readAsBytes();
                          Uint8List smallImgBytes = await smallImg.readAsBytes();
                          String oriImgString = base64Encode(oriImgBytes);
                          String smallImgString = base64Encode(smallImgBytes);

                          //上傳至server
                          _uploadImg(oriImgString, smallImgString);

                          

                          // Uint8List bytes = await oriImg.readAsBytes();
                          // var temp = decodeImageFromList(bytes);
                          
                          
                          // var width = oriImg.
                          //將原圖縮小
                          // File smallImg = await FlutterNativeImage.compressImage(oriImg.path,);
                          

                          // Uint8List bytes = await File(picture.path).readAsBytes();
                          // print(bytes);
                          
                          
                          
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
                    ])
          )
        ]),
      )),
    );
  }
}

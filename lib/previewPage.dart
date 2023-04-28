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
import 'dart:math';
import 'analysisAnimation.dart';
import 'upLoading.dart';
import "package:image_picker/image_picker.dart";
import 'login.dart';
// import 'package:image/image.dart';

// String serverMsg = '';
String account = "";

// var cameraCorrectionFlag = 0;

// 橢圓形畫面class
class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final center = rect.center;
    final radiusX = rect.width * 0.7;
    final radiusY = rect.height * 0.55;
    path.addOval(Rect.fromCenter(center: center, width: radiusX, height: radiusY));
    path.addRect(rect);
    return path..fillType = PathFillType.evenOdd;

  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PreviewPage extends StatelessWidget {
  const PreviewPage(
      {Key? key,
      required this.picture,
      required this.type,
      required this.cameraNum,
      required this.cameraCorrectionFlag,
      })
      : super(key: key);

  final XFile picture;
  final String type;
  final int cameraNum;
  final int cameraCorrectionFlag;

  @override
  Widget build(BuildContext context) {
    String bigImgString = '';
    String smallImgString = '';
    bool firstModifyFlag = true;
    bool imgUploaded = false;
    var oriImgNum = 0;

    // 抓取UserInfo
    _loadUserInfo() async {
      print('loading user info');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = (prefs.getString('account') ?? '');
      // cameraCorrectionFlag = prefs.getInt('cameraCorrectionFlag')??1;
      firstModifyFlag = false;
    }

    if (firstModifyFlag) {
      _loadUserInfo();
    }


    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return Scaffold(
      body: Center(
          child: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.black,
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
                  (cameraCorrectionFlag == 0)
                      ? Container()
                      : 
                      ClipPath(
                        clipper: MyCustomClipper(),
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.6),
                          width: screenWidth,
                          height: screenHeight,
                      ),
                    ),
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
                        print('按下送出按鈕');
                        var oriImg = File(picture.path); //原圖
                        Uint8List oriImgBytes = await oriImg.readAsBytes();
                        String tempImgString = base64Encode(oriImgBytes);

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('tempImgString', tempImgString); // tempImgString 為每次進入分析與畫圖之影像String
                        await prefs.setString('imgFromHistory', 'false');
                        // Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Uploading(),
                              maintainState: true,
                            ),
                          );

                      },
                    ),
                    ElevatedButton(
                      child: Text('重拍'),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal)),
                      onPressed: () async{
                        // 確認該相片是從 相簿 或 相機
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String choosingImgMode = prefs.getString('choosingImgMode')??'camera';

                        if (choosingImgMode == 'camera'){
                          print('camera模式 按下重拍按鈕');
                          Navigator.pop(context);
                        }
                        else{
                          print('album模式 按下重拍按鈕');
                          
                          
                          final ImagePicker picker = new ImagePicker();
                          final pickerImages = await picker.getImage(source: ImageSource.gallery);
                          if(pickerImages != null){
                            Navigator.pop(context);
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PreviewPage(
                                        picture: XFile(pickerImages.path),
                                        type:'gallery',
                                        cameraNum:1,
                                        cameraCorrectionFlag:cameraCorrectionFlag
                                      )));
                            // _userImage = File(pickerImages.path);
                            // print('你選擇的本地路徑是：${_userImage.toString()}');
                          }else{
                            print('沒有照片可以選擇');
                          }
                              
                        }
                        

                      },
                    ),
                  ]))
        ]),
      )),
    );
  }
}

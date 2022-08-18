//相機拍照完的preview
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
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
          Container(
              padding: const EdgeInsets.only(top: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.file(File(picture.path),
                    fit: BoxFit.cover, width: screenWidth - 20),
              )),
          Expanded(
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
                        onPressed: () {
                          log('按下送出按鈕');
                          
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

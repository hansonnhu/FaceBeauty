// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'cameraScreen.dart';
import 'dart:developer';
import 'guide.dart';
import 'register.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'profileModify.dart';
import 'package:camera/camera.dart';

//全域變數

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //傾國
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                    ),
                    child: Row(
                      children: [
                        //app icon
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 5,
                              right: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'iconv3.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),

                        //camera button
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () async {
                              await availableCameras().then((value) =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CameraScreen(cameras: value))));
                            },
                          ),
                        ),

                        //image button
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () async {},
                          ),
                        ),

                        //space
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                          ),
                        ),

                        //history button
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {},
                          ),
                        ),

                        //info button
                        Expanded(
                          flex: 3,
                          child: IconButton(
                            icon: const Icon(
                              Icons.info,
                              color: Colors.white,
                              size: 40,
                            ),
                            onPressed: () {},
                          ),
                        ),

                        //
                        Expanded(
                          flex: 3,
                          child: PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 40,
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              const PopupMenuItem(
                                value: '專家諮詢',
                                child: Text('專家諮詢',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              const PopupMenuItem(
                                value: '帳號編輯',
                                child: Text('帳號編輯',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              const PopupMenuItem(
                                value: '功能介紹',
                                child: Text('功能介紹',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                              // const PopupMenuDivider(),
                              const PopupMenuItem(
                                  value: '設置',
                                  child: Text('設置',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ))),
                            ],
                            onSelected: (value) {
                              if (value == '專家諮詢') {
                                log('點擊專家諮詢');
                              } else if (value == '帳號編輯') {
                                log('點擊帳號編輯');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileModify(),
                                    maintainState: false,
                                  ),
                                );
                              } else if (value == '功能介紹') {
                                log('點擊功能介紹');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Guide(),
                                    maintainState: false,
                                  ),
                                );
                              } else {
                                log('點擊設置');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Home pic
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                  ),
                ),
              ],
            )));
  }
}

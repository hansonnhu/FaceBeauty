// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:facebeauty/history.dart';
import 'package:flutter/material.dart';
import 'cameraScreen.dart';
import 'dart:developer';
import 'guide.dart';
import 'setting.dart';
import 'profileModify.dart';
import 'package:camera/camera.dart';
import "package:image_picker/image_picker.dart";
import 'previewPage.dart';
import 'intro.dart';
import 'doctors.dart';
import 'package:shared_preferences/shared_preferences.dart';

//全域變數
//例項化選擇圖片
final ImagePicker picker = new ImagePicker();
//使用者本地圖片
// File _userImage;//存放獲取到的本地路徑

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var cameraCorrectionFlag = 0;
  bool flagLoaded = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    void getCameraCorrectionFlag() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cameraCorrectionFlag = prefs.getInt('cameraCorrectionFlag') ?? 1;
      flagLoaded == true;
    }

    if (flagLoaded == false) {
      getCameraCorrectionFlag();
    }

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                Container(height: 10,),
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
                                'assets/iconv3.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),

                        //camera button
                        Expanded(flex: 3, child: Container()),

                        //image button
                        Expanded(flex: 3, child: Container()),

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
                        Expanded(flex: 3, child: Container()
                            // child: IconButton(
                            //   icon: const Icon(
                            //     Icons.history,
                            //     color: Colors.white,
                            //     size: 40,
                            //   ),
                            //   onPressed: () {
                            //     print('按下歷史紀錄按鈕');
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => History(),
                            //         maintainState: false,
                            //       ),
                            //     );
                            //   },
                            // ),
                            ),

                        //info button
                        Expanded(flex: 3, child: Container()
                            // child: IconButton(
                            //   icon: const Icon(
                            //     Icons.info,
                            //     color: Colors.white,
                            //     size: 40,
                            //   ),
                            //   onPressed: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => const Intro(),
                            //         maintainState: false,
                            //       ),
                            //     );
                            //   },
                            // ),
                            ),

                        // 隱藏功能按鍵
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Doctors(),
                                    maintainState: false,
                                  ),
                                );
                              } else if (value == '帳號編輯') {
                                log('點擊帳號編輯');
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileModify(),
                                    maintainState: false,
                                  ),
                                );
                              } else if (value == '功能介紹') {
                                log('點擊功能介紹');
                                // Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Guide(),
                                    maintainState: false,
                                  ),
                                );
                              } else {
                                log('點擊設置');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Setting(),
                                    maintainState: false,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // sized box
                Expanded(
                  flex: 4,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/homeImg.gif',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

                // 4種功能按鍵
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //history button
                            SizedBox(
                              height: screenWidth / 3,
                              width: screenWidth / 3,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.history,
                                  color: Colors.white,
                                  size: 80,
                                ),
                                onPressed: () {
                                  print('按下歷史紀錄按鈕');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => History(),
                                      maintainState: false,
                                    ),
                                  );
                                },
                              ),
                            ),

                            //info button
                            SizedBox(
                              height: screenWidth / 3,
                              width: screenWidth / 3,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                splashRadius: 24.0,
                                icon: const Icon(
                                  Icons.info,
                                  color: Colors.white,
                                  size: 80,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Intro(),
                                      maintainState: false,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //camera button
                            SizedBox(
                              height: screenWidth / 3,
                              width: screenWidth / 3,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 80,
                                ),
                                onPressed: () async {
                                  // 選擇相片模式 為 相機
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'choosingImgMode', 'camera');

                                  await availableCameras().then((value) =>
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => CameraScreen(
                                                  cameras: value))));
                                },
                              ),
                            ),

                            //image button
                            SizedBox(
                              height: screenWidth / 3,
                              width: screenWidth / 3,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.image,
                                  color: Colors.white,
                                  size: 80,
                                ),
                                onPressed: () async {
                                  //選擇相簿

                                  // 選擇相片模式 為 相簿
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      'choosingImgMode', 'album');

                                  try {
                                    final pickerImages = await picker.getImage(
                                        source: ImageSource.gallery);
                                    if (mounted) {
                                      setState(() {
                                        if (pickerImages != null) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PreviewPage(
                                                        picture: XFile(
                                                            pickerImages.path),
                                                        type: 'gallery',
                                                        cameraNum: 1,
                                                        cameraCorrectionFlag:
                                                            cameraCorrectionFlag,
                                                      )));
                                          // _userImage = File(pickerImages.path);
                                          // print('你選擇的本地路徑是：${_userImage.toString()}');
                                        } else {
                                          print('沒有照片可以選擇');
                                        }
                                      });
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}

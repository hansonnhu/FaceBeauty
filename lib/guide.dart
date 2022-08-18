// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'home.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

//全域變數
List<String> picSrc = [
  'assets/guide_src1.imageset/guide_src1@1x.png',
  'assets/guide_src2.imageset/guide_src2@3x.png',
  'assets/guide_src3.imageset/guide_src3@3x.png',
  'assets/guide_src4.imageset/guide_src4@3x.png',
  'assets/guide_src5.imageset/guide_src5@3x.png',
];
int srcNum = 0;

class Guide extends StatefulWidget {
  const Guide({Key? key}) : super(key: key);

  @override
  _GuideState createState() => _GuideState();
}

class _GuideState extends State<Guide> {
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
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'iconv3.png',
                          width: 38,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '傾國',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //guide pic
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Image.asset(
                      picSrc[srcNum],
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),

                //跳過與繼續按鈕
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              child: Text('跳過'),
                              style: ElevatedButton.styleFrom(
                                  onSurface: Colors.white60,
                                  primary: Colors.black54,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal)),
                              onPressed: () {
                                log('按下跳過按鈕');
                                Navigator.pop(context,);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                    maintainState: false,
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              child: Text('繼續'),
                              style: ElevatedButton.styleFrom(
                                  onSurface: Colors.white60,
                                  primary: Colors.black54,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal)),
                              onPressed: () {
                                log('按下繼續按鈕');
                                if (srcNum != 4) {
                                  srcNum = srcNum + 1;
                                  setState(() {});
                                } else {
                                  log('指引結束');
                                  srcNum = 0;
                                  Navigator.pop(context,);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Home(),
                                      maintainState: false,
                                    ),
                                  );
                                }
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const Register(),
                                //     maintainState: false,
                                //   ),
                                // );
                              },
                            ),
                          ]),
                    )),
              ],
            )));
  }
}

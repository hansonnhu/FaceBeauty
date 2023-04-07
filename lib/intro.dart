// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:facebeauty/home.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'guide.dart';
import 'package:shared_preferences/shared_preferences.dart';

String iniAccount = "";
String iniPassword = "";

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.black,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //傾國
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 40,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/iconv3.png',
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

                //intor text
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 40,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            '漂亮容貌主要是在評估臉部五官和輪廓相輔相成之綜和美感。除對稱與自然外，需要再加上協調比例。' +
                                '每個時代對於美感會略有改變，且抽象之「五官端正」或「漂亮美麗」也無法量化，但令人觀之舒服之五官比例，確實有跡可循' +
                                '元代畫家王繹於《寫像秘訣》記載畫肖像畫訣竅：「寫真之法，先觀八格，次看三庭。眼橫五配，口約三勻。明其大局，好定寸分。\n' +
                                '以下三類分析方式最廣為人知：\n' +
                                '「三庭五眼」：全臉比例\n' +
                                '「四高三低」：全臉比例\n' +
                                '「TVR」:局部線條之立體與和諧',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ))),

                //繼續按鈕
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 40,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('繼續'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下繼續按鈕');
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            int guideFlag = prefs. getInt('guideFlag') ?? 1;
                            
                            if(guideFlag == 1){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Guide(),
                                  maintainState: false,
                                ),
                              );
                            }else{
                              Navigator.of(context).popUntil((route) {
                                  // print(route.toString());
                                  return route.settings.name == "/" ? true : false;
                                },);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                    maintainState: false,
                                  ),
                                );
                            }
                            
                          },
                        ),
                      ]),
                )
              ],
            )));
  }
}

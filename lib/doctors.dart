// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';


String iniAccount = "";
String iniPassword = "";



class Doctors extends StatefulWidget {
  const Doctors({Key? key}) : super(key: key);

  @override
  _DoctorsState createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(15),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //傾國
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
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
                        width: 20,
                      ),
                      const Text(
                        '專家諮詢',
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
                          bottom: 10,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Image.asset(
                              'assets/ad.imageset/ad@3x.png',
                              fit: BoxFit.fitWidth,
                            ),
                            // SizedBox(height: 5,),
                            Container(
                              width:screenWidth,
                              alignment: Alignment.centerLeft,  
                              child:TextButton(
                                onPressed: ()async{
                                  print('按下 詳細資訊...');
                                  const url1 = 'https://drhsu.com.tw/';
                                  if (await canLaunchUrl(Uri.parse(url1))){
                                    await launchUrl(Uri.parse(url1,));
                                  }
                                  else{
                                    throw "Could not launch url1";
                                  }
                                },
                                child: const Text(
                                  '詳細資訊...',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                  // textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20,),
                            Image.asset(
                              'assets/ad2.imageset/ad2@3x.png',
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              width:screenWidth,
                              alignment: Alignment.centerLeft,  
                              child:TextButton(
                                onPressed: ()async{
                                  print('按下 詳細資訊...');
                                  const url2 = 'http://www2.kmuh.org.tw/web/kmuhdept/0270/醫師簡介/賴春生教授.aspx';
                                  if (await canLaunchUrl(Uri.parse(url2),)){
                                    await launchUrl(Uri.parse(url2));
                                  }
                                  else{
                                    throw "Could not launch url2";
                                  }
                                },
                                child: const Text(
                                  '詳細資訊...',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                  // textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            
                          ],)
                        ))),

                //繼續按鈕
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          child: Text('返回'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下返回按鈕');
                            
                            Navigator.pop(context);
                            
                          },
                        ),
                      ]),
                )
              ],
            )));
  }
}

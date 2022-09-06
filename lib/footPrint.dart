// app的一些設定調整(綁定硬體裝置)
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'result.dart';

String iniAccount = "";
String iniPassword = "";

String userName = ''; //使用者名稱
List<String> allDateTimeList = []; //所有 DateTime string

//下載所有的 oriImg
List<String> allOriImgString = [];
List<Uint8List> allOriImgByteString = [];
int oriImgCount = 0;

class FootPrint extends StatefulWidget {
  const FootPrint({Key? key}) : super(key: key);

  @override
  _FootPrintState createState() => _FootPrintState();
}

class _FootPrintState extends State<FootPrint> {
  bool isFirstLoad = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    

    //於資料庫抓取data
    _loadData() async {
      print('第一次進 FootPrint !');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      allOriImgString = await prefs.getStringList('oriImgStringList') ?? [];
      oriImgCount = allOriImgString.length;
      userName = prefs.getString('account') ?? '';
      allDateTimeList = prefs.getStringList('allDateTimeList') ?? [];

      print(userName);
      print('count = ' + oriImgCount.toString());

      // for(int i=0;i<oriImgCount;i++){
      //   allOriImgByteString[i] = await base64Decode(allOriImgString[i]);
      // }

      isFirstLoad = false;
      setState(() {});
    }

    if (isFirstLoad) _loadData();

    return Scaffold(
        body: Container(
            padding:
                const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //美麗足跡
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '美麗足跡',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
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
                        child: ListView.builder(
                            padding: new EdgeInsets.only(top: 0, bottom: 0),
                            itemCount: oriImgCount,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () async {
                                    print('選擇 oriImgIndex 為 : ' +
                                        index.toString());
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt('oriImgIndex', index);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Result(),
                                        maintainState: false,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    height: 80,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.white))),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.memory(
                                              (base64Decode(
                                                  allOriImgString[index])),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                userName,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 5,
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                allDateTimeList[index],
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                )))),

                //按鈕
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //清除按鈕
                        ElevatedButton(
                          child: Text('清除'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下清除按鈕');
                          },
                        ),
                        //趨勢按鈕
                        ElevatedButton(
                          child: Text('趨勢'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下趨勢按鈕');
                          },
                        ),
                        //返回按鈕
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

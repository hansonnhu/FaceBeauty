// app的一些設定調整(綁定硬體裝置)
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'result.dart';
import 'allTrend.dart';

String iniAccount = "";
String iniPassword = "";
String account = '';


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
  bool dataLoadedFlag = false;
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    

    //於資料庫抓取data
    _loadData() async {
      print('第一次進 FootPrint !');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('newImgData?', 0);
      account = prefs.getString('account') ?? '';
      print(account);

      allOriImgString = prefs.getStringList(account+'oriImgStringList') ?? [];
      oriImgCount = allOriImgString.length;
      userName = prefs.getString('account') ?? '';
      allDateTimeList = prefs.getStringList(account+'allDateTimeList') ?? [];

      print(userName);
      print('count = ' + oriImgCount.toString());

      // for(int i=0;i<oriImgCount;i++){
      //   allOriImgByteString[i] = await base64Decode(allOriImgString[i]);
      // }

      dataLoadedFlag = true;
      setState(() {});
    }

    if (dataLoadedFlag == false) _loadData();

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
                              primary: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下清除按鈕');

                            // 跳出警示視窗確認user是否真的要刪除所有分析紀錄
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                title: const Text('警告'),
                                content: const Text('確定刪除所有分析紀錄?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, '取消'),
                                    child: const Text('取消'),
                                  ),
                                  TextButton(
                                    child:  Text('確定'),
                                    onPressed: () async{
                                        Navigator.pop(context, '確定');

                                        // 清除所有分析紀錄
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.setStringList(account+'oriImgStringList',[]); // oriImgStringList 清空
                                        await prefs.setStringList(account+'resultAllMsgList', []);// resultAllMsgList 清空
                                        await prefs.setStringList(account+'allDateTimeList',[]);// allDateTimeList 清空
                                        for(int i = 0; i < 34;i++){ // ratio_0 ~ ratio_33 list 清空
                                          String tempName = 'ratio_' + i.toString();
                                          await prefs.setStringList(account+tempName, []);
                                        }
                                        _loadData();
                                    }
                                  )
                                ],
                              ),
                            );
                            
                            
                          },
                        ),
                        //趨勢按鈕
                        ElevatedButton(
                          child: Text('趨勢'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.green.shade900,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下趨勢按鈕');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllTrend(),
                                maintainState: false,
                              ),
                            );
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

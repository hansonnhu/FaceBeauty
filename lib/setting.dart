// app的一些設定調整(綁定硬體裝置)
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



String iniAccount = "";
String iniPassword = "";

// setting 參數
// int welcomeFlag = 1; // 是否顯示 歡迎 page
// int guideFlag = 1; // 是否顯示 導覽 page
// int passwordRememberFlag = 1; // 是否記住帳號密碼
// int cameraCorrectionFlag = 1; // 是否顯示相機畫面校正人框
// int cameraDiractionFlag = 1; // 是否允許相機切換前後鏡頭
// int detectImmediatelyFlag = 1; // 是否載入即時偵測
// int syncFootprintFlag = 1; // 是否自動同步足跡

//所有的 flags list
List<int> allFlag = [
  0,
  0,
  0,
  0,
  // 0,
  // 0,
  // 0
];
List<String> allFlagString = [
  'welcomeFlag',
  'guideFlag',
  'passwordRememberFlag',
  'cameraCorrectionFlag',
  // 'cameraDiractionFlag',
  // 'detectImmediatelyFlag',
  // 'syncFootprintFlag'
];

//所有 flag 的 title
List<String> allTitle = [
  '歡迎使用介面',
  '新手導覽教學',
  '記住帳號密碼',
  '矯正視窗顯示',
  // '相機鏡頭方向',
  // '載入即時偵測',
  // '自動同步足跡'
];

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isFirstLoad = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    //於資料庫抓取data
    _loadData() async {
      print('第一次進 setting !');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for(int i = 0;i<allTitle.length;i++){
        allFlag[i] = prefs.getInt(allFlagString[i]) ?? 1;
      }
      isFirstLoad = false;
      setState(() {});
    }
    if(isFirstLoad)
      _loadData();

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
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '設置',
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
                    child: 
                    !isFirstLoad ?
                    Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 40,
                        ),
                        child: ListView.builder(
                          padding: new EdgeInsets.only(top: 5, bottom: 5),
                          itemCount: allTitle.length,
                          itemBuilder: (context, index) => Container(
                              child: CheckboxListTile(
                            title: Text(
                              allTitle[index],
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ), //    <-- label
                            value: allFlag[index] == 1 ? true : false,
                            onChanged: (newValue) {
                              if (newValue == true) {
                                allFlag[index] = 1;
                              } else {
                                allFlag[index] = 0;
                              }
                              setState(() {});
                            },
                          )),
                        )) : Container()),

                //按鈕
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //確定按鈕
                        ElevatedButton(
                          child: Text('確定'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下確定按鈕');
                            //將更改後的 flags 寫入資料庫
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            for(int i = 0;i<allTitle.length;i++){
                              await prefs.setInt(allFlagString[i], allFlag[i]);
                            } 
                            Navigator.pop(context);

                            //AlertDialog
                            BuildContext dialogContext = context;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return const AlertDialog(
                                    title: Text('修改成功!'),
                                    content: Text('修改中......'),
                                  );
                                });
                            //延遲一秒後跳轉進入APP
                            await Future.delayed(Duration(milliseconds: 1000),
                                () {
                              Navigator.pop(dialogContext);
                              // Navigator.pop(context);
                            });
                          },
                        ),
                        //取消按鈕
                        ElevatedButton(
                          child: Text('取消'),
                          style: ElevatedButton.styleFrom(
                              onSurface: Colors.white60,
                              primary: Colors.teal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.normal)),
                          onPressed: () async {
                            log('按下取消按鈕');
                            
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                )
              ],
            )));
  }
}

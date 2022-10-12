// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'dart:ffi';

import 'package:facebeauty/guide.dart';
import 'package:facebeauty/welcome.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'register.dart';
import 'intro.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';



String iniAccount = "";
String iniPassword = "";
TextEditingController accountCon = TextEditingController();
TextEditingController passwordCon = TextEditingController();

void hideKeyboard() { // 按空白處影藏鍵盤
  FocusManager.instance.primaryFocus?.unfocus();
}
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool firstLoginFlag = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度


    //判斷帳號密碼是否只有英文或數字
    bool stringFilter(String str) {
      var oriLen = str.length;
      String temp = '';
      temp = str.replaceAll(RegExp('[A-Z]'), '');
      temp = temp.replaceAll(RegExp('[a-z]'), '');
      temp = temp.replaceAll(RegExp('[0-9]'), '');
      log(temp.length.toString());

      if (temp.length == 0) {
        return true;
      } else {
        return false;
      }
    }

    //抓取UserInfo
    _loadUserInfo() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      iniAccount = (prefs.getString('account') ?? '');
      iniPassword = (prefs.getString('password') ?? '');
      accountCon..text = iniAccount;
      passwordCon..text = iniPassword;
      firstLoginFlag = false;

      setState(() {});
    }

    if (firstLoginFlag) {
      _loadUserInfo();
    }

    //更改userInfo
    _modifyUserInfo(TextEditingController accountCon,
        TextEditingController passwordCon) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('account', accountCon.text);
      prefs.setString('password', passwordCon.text);
    }


    return 
    Listener(
            onPointerDown: (_) => hideKeyboard(),
            child:
    Scaffold(
      
      body: 
      firstLoginFlag == true ? Container():
      Container(
          padding: const EdgeInsets.all(30),
          color: Colors.black87,
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
                  mainAxisAlignment: MainAxisAlignment.start,
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

              //帳號
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: const [
                              Text(
                                '帳號',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //帳號輸入欄位
                    Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((20.0)),
                        ),
                        child: TextField(
                          controller: TextEditingController.fromValue(TextEditingValue(
                  // 设置内容
                  text: iniAccount,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: iniAccount.length)))),
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: '',
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 10,
                              color: Colors.white,
                            )),
                          ),
                          onChanged: (text) {
                            iniAccount = text;
                            accountCon..text = text;
                          },
                        )),

                    //密碼
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: const [
                              Text(
                                '密碼',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //密碼輸入欄位
                    Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular((20.0)),
                        ),
                        child: TextField(
                          controller: TextEditingController.fromValue(TextEditingValue(
                  // 设置内容
                  text: iniPassword,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: iniPassword.length)))),
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: '',
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 10,
                              color: Colors.white,
                            )),
                          ),
                          onChanged: (text) {
                            iniPassword = text;
                            passwordCon..text = text;
                          },
                        )),

                    //登入與註冊
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            child: Text('登入'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal)),
                            onPressed: () async {
                              log('按下登入按鈕');
                              print(accountCon.text);
                              print(passwordCon.text);

                              if (accountCon.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('錯誤'),
                                    content: const Text('帳號不能為空!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (passwordCon.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('錯誤'),
                                    content: const Text('密碼不能為空!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (!stringFilter(accountCon.text) ||
                                  !stringFilter(passwordCon.text)) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('錯誤'),
                                    content: const Text('帳號或密碼出現非數字或英文!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                //若帳號密碼格式無誤

                                //與server溝通
                                Socket socket = await Socket.connect(
                                    '140.117.168.12', 54915);
                                print(
                                    'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
                                // listen to the received data event stream
                                socket.listen((List<int> event) async {
                                  //print出server回傳data
                                  print(utf8.decode(event));
                                  String serverMsg = utf8.decode(event);
                                  
                                  if (serverMsg == 'fail;') {
                                    socket.close();
                                    //AlertDialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('登入失敗'),
                                        content:
                                            const Text('帳號或密碼錯誤\n請重新輸入帳號密碼'),
                                        actions: <Widget>[
                                          // TextButton(
                                          //   onPressed: () =>
                                          //       Navigator.pop(context, 'Cancel'),
                                          //   child: const Text('Cancel'),
                                          // ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (serverMsg == 'success;') {
                                    //登入成功
                                    //關閉socket
                                    socket.close();

                                    //更改UsrInfo
                                    _modifyUserInfo(accountCon, passwordCon);

                                    //AlertDialog
                                    BuildContext dialogContext = context;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          dialogContext = context;
                                          return const AlertDialog(
                                            title: Text('登入成功!'),
                                            content: Text('登入中......'),
                                          );
                                        });

                                    //延遲一秒後跳轉進入APP
                                    //查看資料庫，依照flag情形決定要跳轉之畫面(一開始共有welcome, intro, guide 頁面)
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    int welcomeFlag = prefs.getInt('welcomeFlag') ?? 1;//若為0，直接跳過 welcome, intro 頁面
                                    int guideFlag = prefs.getInt('guideFlag') ?? 1;//若為0，跳過guide

                                    await Future.delayed(
                                        Duration(milliseconds: 1000), () {
                                      Navigator.pop(dialogContext);
                                      // push首頁進進去
                                      
                                    // if (!(welcomeFlag == 0 && guideFlag == 0)){
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => const Home(),
                                    //       maintainState: false,
                                    //     ),
                                    //   );
                                    // }
                                      

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => (welcomeFlag == 1) ? const Welcome() : (guideFlag == 1) ? const Guide() : Home(),
                                          maintainState: false,
                                        ),
                                      );
                                    });
                                  }
                                });
                                String msg = accountCon.text +
                                    ';' +
                                    passwordCon.text +
                                    '<';
                                // send hello
                                socket.add(utf8.encode(msg));

                                // wait 5 seconds
                                await Future.delayed(Duration(seconds: 2));

                                // .. and close the socket
                                socket.close();
                              }
                              // log("${myController.text}");
                            },
                          ),
                          ElevatedButton(
                            child: Text('註冊'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.yellow[600],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                textStyle: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.normal)),
                            onPressed: () {
                              log('按下註冊按鈕');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                  maintainState: false,
                                ),
                              );
                              // log('account: ${account.text}');
                              // log('password: ${password.text}');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ],
          )),
    ));
  }
}

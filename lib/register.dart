import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'guide.dart';
import 'welcome.dart';
import 'parameter.dart';

void hideKeyboard() {
  // 按空白處影藏鍵盤
  FocusManager.instance.primaryFocus?.unfocus();
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool termIsChecked = false;
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String registerAccount = "";
  String registerPassword = "";

  @override
  void dispose() {
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    //判斷帳號密碼是否只有盈文或數字
    bool stringFilter(String str) {
      var oriLen = str.length;
      String temp = '';
      temp = str.replaceAll(RegExp('[A-Z]'), '');
      temp = temp.replaceAll(RegExp('[a-z]'), '');
      temp = temp.replaceAll(RegExp('[0-9]'), '');
      print(temp.length.toString());

      if (temp.length == 0) {
        return true;
      } else {
        return false;
      }
    }

    // get color function
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    // final TextEditingController registerAccount = TextEditingController();
    // final TextEditingController registerPassword = TextEditingController();

    return Listener(
        onPointerDown: (_) => hideKeyboard(),
        child: Scaffold(
            body: Container(
          padding: const EdgeInsets.all(30),
          color: Colors.black,
          width: screenWidth,
          height: screenHeight,
          child: Container(
            child: Column(
              children: [
                //帳號 - 5~16英數
                // Expanded(
                //   flex:1,
                //   child: Container()
                // ),
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
                            '帳號 - 5~16英數',
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
                      // controller: registerAccount..text = registerAccount,
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      keyboardType: TextInputType.text,

                      // initialValue: 'registerAccount',
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
                        registerAccount = text;
                      },
                    )),

                //密碼 - 5~16英數
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
                            '密碼 - 5~16英數',
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
                      // controller: registerPassword..text = registerPassword,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      keyboardType: TextInputType.text,
                      // initialValue: 'registerPassword',
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
                        registerPassword = text;
                      },
                    )),
                //同意使用條例

                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: termIsChecked,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          onChanged: (bool? value) {
                            // log(value.toString());
                            if (mounted) setState(() {
                              termIsChecked = value!;
                            });
                          },
                        ),
                        const Text(
                          '同意使用條約',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),

                //註冊按鈕
                Container(
                  height: screenHeight * 0.1,
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text('註冊'),
                        style: ElevatedButton.styleFrom(
                            onSurface: Colors.white60,
                            primary: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.normal)),
                        onPressed: termIsChecked
                            ? () async {
                                print('按下註冊按鈕');
                                BuildContext dialogContext = context;
                                if (registerAccount == '') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        dialogContext = context;
                                        return AlertDialog(
                                          title: const Text('錯誤'),
                                          content: const Text('帳號不能為空!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                } else if (registerPassword == '') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        dialogContext = context;
                                        return AlertDialog(
                                          title: const Text('錯誤'),
                                          content: const Text('密碼不能為空!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                } else if (registerAccount.length < 5 ||
                                    registerAccount.length > 16 ||
                                    registerPassword.length < 5 ||
                                    registerPassword.length > 16) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        dialogContext = context;
                                        return AlertDialog(
                                          title: const Text('錯誤'),
                                          content: const Text('帳號或密碼長度不正確!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                } else if (!stringFilter(registerAccount) ||
                                    !stringFilter(registerPassword)) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        dialogContext = context;
                                        return AlertDialog(
                                          title: const Text('錯誤'),
                                          content: const Text('帳號或密碼出現非數字或英文!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  dialogContext, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  //若帳號密碼格式無誤
                                  //與server溝通
                                  Socket socket = await Socket.connect(
                                      serverIP, serverPort);
                                  print(
                                      'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
                                  // listen to the received data event stream

                                  String serverMsg = '';
                                  socket.listen((List<int> event) async {
                                    //print出server回傳data
                                    print(utf8.decode(event));
                                    serverMsg = utf8.decode(event);
                                  });

                                  // send hello
                                  // 傳送訊息給server
                                  var randomNum = Random().nextInt(100000);
                                  String tempClientNumString = registerAccount +
                                      ':' +
                                      randomNum.toString();
                                  String msg = 'startCode103040023<' +
                                      tempClientNumString +
                                      '<' +
                                      'register' +
                                      '<' +
                                      registerAccount +
                                      '<' +
                                      registerPassword +
                                      ';';
                                  List<int> msgBytes = [];
                                  msgBytes.addAll(utf8.encode(msg));
                                  msgBytes.add(0);
                                  socket.add(msgBytes);

                                  // listen to the received data event stream
                                  while (true) {
                                    await Future.delayed(
                                        Duration(milliseconds: 500));

                                    if (serverMsg == 'fail;') {
                                      // 要求server斷線
                                      // String msg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
                                      // List<int> msgBytes = [];
                                      // msgBytes.addAll(utf8.encode(msg));
                                      // msgBytes.add(0);
                                      // socket.add(msgBytes);
                                      socket.close();

                                      //AlertDialog
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            dialogContext = context;
                                            return AlertDialog(
                                              title: const Text('註冊失敗'),
                                              content: const Text(
                                                  '該帳號已存在\n請重新輸入帳號密碼'),
                                              actions: <Widget>[
                                                // TextButton(
                                                //   onPressed: () => Navigator.pop(
                                                //       dialogContext, 'Cancel'),
                                                //   child: const Text('Cancel'),
                                                // ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          dialogContext, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                      break;
                                    } else if (serverMsg == 'success;') {
                                      // 要求server斷線
                                      // String msg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
                                      // List<int> msgBytes = [];
                                      // msgBytes.addAll(utf8.encode(msg));
                                      // msgBytes.add(0);
                                      // socket.add(msgBytes);
                                      socket.close();

                                      //pop
                                      Navigator.pop(context);

                                      //查看資料庫，依照flag情形決定要跳轉之畫面(一開始共有welcome, intro, guide 頁面)
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      int welcomeFlag =
                                          prefs.getInt('welcomeFlag') ??
                                              1; //若為0，直接跳過 welcome, intro 頁面
                                      int guideFlag =
                                          prefs.getInt('guideFlag') ??
                                              1; //若為0，跳過guide
                                      //設定帳號密碼
                                      await prefs.setString(
                                          'account', registerAccount);
                                      await prefs.setString(
                                          'password', registerPassword);

                                      //push
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              (welcomeFlag == 1)
                                                  ? const Welcome()
                                                  : (guideFlag == 1)
                                                      ? const Guide()
                                                      : Home(),
                                          maintainState: false,
                                        ),
                                      );

                                      //AlertDialog
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            dialogContext = context;
                                            return AlertDialog(
                                              title: const Text('註冊成功，已登入'),
                                              content: const Text(''),
                                              actions: <Widget>[
                                                // TextButton(
                                                //   onPressed: () => Navigator.pop(
                                                //       dialogContext, 'Cancel'),
                                                //   child: const Text('Cancel'),
                                                // ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          dialogContext, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            );
                                          });
                                      break;
                                    }
                                  }

                                  // wait 5 seconds
                                  await Future.delayed(Duration(seconds: 5));

                                  // .. and close the socket
                                  socket.close();
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
                //版權宣告
                Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: const Text(
                              '版權宣告',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          //中山大學 影像處理實驗室 版權所有
                          Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: const Text(
                              '中山大學 影像處理實驗室 版權所有',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          Container(
                              // flex:5,
                              // color: Colors.green,
                              child: const SingleChildScrollView(
                                  child: Text(
                            '一、【傾國】由國立中山大學影像處理實驗室規劃製作，並受中華民國著作權法及商標法所保護。' +
                                '\n\n二、【傾國】所使用之內容，包括著作、圖片、檔案、資訊、資料、內容，均由國立中山大學影像處理實驗室依法擁有其智慧財產，' +
                                '非經軟體書面授權同意，不得以任何形式轉載、傳輸、再製、散布、顯示、出版、傳播、進行還原工程、解編或反向組譯。' +
                                '若違反將依法提起告訴，並請求賠償。' +
                                '\n\n三、【傾國】中所提及，由國立中山大學影像處理實驗室自行研發之軟體程式及文件為國立中山大學影像處理實驗室所有，' +
                                '其中包括但不限於著作權，並受中華民國著作權法所保護。' +
                                '\n\n四、任何人均不得以任何方式企圖破壞及干擾本自動化辨識系統各項資料與功能，且嚴禁任何未經授權入侵或破壞任何系統，' +
                                '否則國立中山大學影像處理實驗室將依法提出法律告訴，並請求賠償（包括但不限於訴訟費用及律師費用等）。' +
                                '\n\n©2019 - 國立中山大學 影像處理實驗室',
                            style: TextStyle(color: Colors.white),
                          )))
                        ],
                      ),
                    ))
              ],
            ),
          ),
        )));
  }
}

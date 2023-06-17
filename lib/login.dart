import 'package:facebeauty/guide.dart';
import 'package:facebeauty/welcome.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'dart:math';
import 'parameter.dart';
import 'package:flutter/material.dart';





var passwordRememberFlag = 0;
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
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String iniAccount = "";
  String iniPassword = "";
  @override
  void dispose() {
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    
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

    //判斷帳號密碼是否只有英文或數字
    bool stringFilter(String str) {
      var oriLen = str.length;
      String temp = '';
      temp = str.replaceAll(RegExp('[A-Z]'), '');
      temp = temp.replaceAll(RegExp('[a-z]'), '');
      temp = temp.replaceAll(RegExp('[0-9]'), '');
      // log(temp.length.toString());

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
      passwordRememberFlag = prefs.getInt('passwordRememberFlag') ?? 1;
      accountCon.text = iniAccount;
      passwordCon.text = iniPassword;
      print('passwordRememberFlag 為 ');
      print(passwordRememberFlag);
      if(passwordRememberFlag == 0){
        iniAccount = '';
        iniPassword = '';
      }
      _usernameController.text = iniAccount;
      _passwordController.text = iniPassword;
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
      await prefs.setString('account', iniAccount);
      await prefs.setString('password', iniPassword);
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
          color: Colors.black,
          width: screenWidth,
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                flex: 10,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
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
                          
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular((50.0)),
                          ),
                          child: TextField(
                            // controller: _usernameController..text = iniAccount,
                            controller: _usernameController,
                            focusNode: _usernameFocus,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              // labelText: 'Username',
                              // hintText: 'Enter your username',
                              // hintText: '',
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
                              accountCon.text = text;
                            },
                            onTap: () {
                              if (!_usernameFocus.hasFocus) {
                                _usernameFocus.requestFocus();
                              }
                              final TextEditingValue value = _usernameController.value;
                              _usernameController.selection = TextSelection(
                                baseOffset: value.selection.baseOffset,
                                extentOffset: value.selection.extentOffset);
                            },
                            
                          )
                        ),
                
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular((20.0)),
                          ),
                          child: 
                          TextField(
                            
                            // controller: _passwordController..text = iniPassword,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(2),
                              // labelText: 'Username',
                              // hintText: 'Enter your password',
                              // hintText: '',
                              filled: true,
                              fillColor: Colors.white70,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 10,
                                color: Colors.white,
                              )),
                            ),
                            obscureText: true,
                            onChanged: (text) {
                              iniPassword = text;
                              passwordCon.text = text;
                            },
                            onTap: () {
                              if (!_passwordFocus.hasFocus) {
                                _passwordFocus.requestFocus();
                              }
                            },
                          )
                        ),
                
                      //登入與註冊
                      Container(
                        padding: const EdgeInsets.only(
                          top: 30,
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
                                print('按下登入按鈕');
                                print(iniAccount);
                                print(iniPassword);
                
                                if (iniAccount == '') {
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
                                } else if (iniPassword == '') {
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
                                } else if (!stringFilter(iniAccount) ||
                                    !stringFilter(iniPassword)) {
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
                                  Socket socket = await Socket.connect(serverIP, serverPort);
                                  print(
                                      'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
                                  // listen to the received data event stream
                
                                  
                                  String serverMsg = '';
                                  socket.listen((List<int> event) async {
                                    //print出server回傳data
                                    print(utf8.decode(event));
                                    serverMsg = utf8.decode(event);
                                  });
                                  
                                  // 傳送訊息給server
                                  var randomNum = Random().nextInt(100000);
                                  String tempClientNumString = iniAccount + ':' + randomNum.toString();
                                  String msg = 'startCode103040023<' + tempClientNumString + '<' + 'login' + '<' + iniAccount + '<' + iniPassword + ';';
                                  List<int> msgBytes = [];
                                  msgBytes.addAll(utf8.encode(msg));
                                  msgBytes.add(0);
                                  socket.add(msgBytes);
                
                                  // wait 0.5 seconds
                                  while(true){
                                    await Future.delayed(Duration(milliseconds: 500));
                
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
                                      break;
                                    } else if (serverMsg == 'success;') {
                                      //登入成功
                                      // 要求server斷線
                                      // String msg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
                                      // List<int> msgBytes = [];
                                      // msgBytes.addAll(utf8.encode(msg));
                                      // msgBytes.add(0);
                                      // socket.add(msgBytes);
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
                                          Duration(milliseconds: 1000), () async{
                                        Navigator.pop(dialogContext);
                                        // push首頁進進去  
                       
                
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => (welcomeFlag == 1) ? const Welcome() : (guideFlag == 1) ? const Guide() : Home(),
                                            maintainState: false,
                                          ),
                                        );
                                      });
                                      break;
                                    }
                                  }
                                  // .. and close the socket
                                  socket.close();
                                }
                                // log("${myController.text}");
                              },
                            ),
                            ElevatedButton(
                              child: Text('註冊'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow[900],
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal)),
                              onPressed: () {
                                print('按下註冊按鈕');
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
              ),
              Expanded(
                flex:1,
                  child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    
                    children: [
                      Text(
                        '記住密碼',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Checkbox(
                        fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                        value: passwordRememberFlag == 1 ? true : false,
                        onChanged: (newValue) async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          if (newValue == true) {
                            print('true');
                            passwordRememberFlag = 1;
                          } else {
                            print('false');
                            passwordRememberFlag = 0;
                            await prefs.setString('password', '');
                            await prefs.setString('account', '');
                          }
                          await prefs.setInt('passwordRememberFlag', passwordRememberFlag);
                          setState(() {});
                        },
                      )
                    ],
                  ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          )),
    ));
  }
}

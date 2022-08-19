// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'home.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

bool firstModifyFlag = true;
List<String> userInfo = [];
String account = "";
String name = "";
String gender = "";
String age = "";
String weight = "";
String phone = "";
String email = "";
String address = "";
String doctor = "";

class ProfileModify extends StatefulWidget {
  const ProfileModify({Key? key}) : super(key: key);

  @override
  _ProfileModifyState createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
  

  @override
  Widget build(BuildContext context) {
    
    _loadUserInfo() async {// 抓取UserInfo
      log('loading user info');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = (prefs.getString('account') ?? '');

      //與server溝通
      Socket socket = await Socket.connect('140.117.168.12', 54444);
      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        String serverMsg = utf8.decode(event);
        print(serverMsg);
        userInfo = serverMsg.split("&");
        print(userInfo);
        name = userInfo[0];
        gender = userInfo[1];
        age = userInfo[2];
        weight = userInfo[3];
        phone = userInfo[4];
        email = userInfo[5];
        address = userInfo[6];
        doctor = userInfo[7].split(';')[0];
      });

      String msg = account + ";";

      // send hello
      socket.add(utf8.encode(msg));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 5));

      // .. and close the socket
      socket.close();
      firstModifyFlag = false;
      setState(() {});
      
    }

    if (firstModifyFlag == true) {
      log('第一次進編輯頁面');
      _loadUserInfo();
    };

    //更改userInfo
    _modifyUserInfo(nameCon, genderCon, ageCon, weightCon, phoneCon, emailCon,
        addressCon, doctorCon) async {
      //與server溝通
      Socket socket = await Socket.connect('140.117.168.12', 54544);
      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        print(utf8.decode(event));
      });
      String msg = account +
          "<" +
          nameCon.text +
          "<" +
          genderCon.text +
          "<" +
          ageCon.text +
          "<" +
          weightCon.text +
          "<" +
          phoneCon.text +
          "<" +
          emailCon.text +
          "<" +
          addressCon.text +
          "<" +
          doctorCon.text +
          ";";
      // send hello
      socket.add(utf8.encode(msg));
      // wait 5 seconds
      await Future.delayed(Duration(seconds: 5));
      // .. and close the socket
      socket.close();
    }

    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    final TextEditingController nameCon = TextEditingController();
    final TextEditingController genderCon = TextEditingController();
    final TextEditingController ageCon = TextEditingController();
    final TextEditingController weightCon = TextEditingController();
    final TextEditingController phoneCon = TextEditingController();
    final TextEditingController emailCon = TextEditingController();
    final TextEditingController addressCon = TextEditingController();
    final TextEditingController doctorCon = TextEditingController();

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //個人資料
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '個人資料',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                //姓名
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
                              const Text(
                                '姓名',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: nameCon..text = name,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //性別
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '性別',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: genderCon..text = gender,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //年齡
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '年齡',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: ageCon..text = age,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //體重
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '體重',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: weightCon..text = weight,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //電話
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '電話',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: phoneCon..text = phone,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //信箱
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '信箱',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: emailCon..text = email,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //地址
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '地址',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: addressCon..text = address,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),

                        //醫師
                        Container(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                '醫師',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: TextField(
                                controller: doctorCon..text = doctor,
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
                                onChanged: (text) {},
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //按鈕們

                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text('完成'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.normal)),
                        onPressed: () async {
                          log('按下完成按鈕');
                          //AlertDialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const AlertDialog(
                              title: Text('修改成功!'),
                              content: Text('修改中......'),
                            ),
                          );

                          //更新userInfo至server
                          _modifyUserInfo(nameCon, genderCon, ageCon, weightCon,
                              phoneCon, emailCon, addressCon, doctorCon);

                          //延遲一秒後跳轉進入APP
                          Future.delayed(Duration(milliseconds: 1000), () {
                            Navigator.pop(context);
                          });
                          // 重新從server下載userInfo
                          _loadUserInfo();
                          setState(() {});
                          // log("${myController.text}");
                        },
                      ),
                      ElevatedButton(
                        child: Text('取消'),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.yellow[600],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.normal)),
                        onPressed: () {
                          log('按下取消按鈕');
                          // Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                              maintainState: false,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

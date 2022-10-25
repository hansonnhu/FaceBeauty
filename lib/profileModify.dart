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
// import 'package:big5/big5.dart';


TextEditingController nameCon = TextEditingController();
TextEditingController genderCon = TextEditingController();
TextEditingController ageCon = TextEditingController();
TextEditingController weightCon = TextEditingController();
TextEditingController phoneCon = TextEditingController();
TextEditingController emailCon = TextEditingController();
TextEditingController addressCon = TextEditingController();
TextEditingController doctorCon = TextEditingController();

void hideKeyboard() { // 按空白處影藏鍵盤
  FocusManager.instance.primaryFocus?.unfocus();
}
class ProfileModify extends StatefulWidget {
  const ProfileModify({Key? key}) : super(key: key);

  @override
  _ProfileModifyState createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度


    _loadUserInfo() async {
      // 抓取UserInfo
      log('loading user info');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = (prefs.getString('account') ?? '');

      //與server溝通
      Socket socket = await Socket.connect('140.117.168.12', 54444);
      print('connected');

      // listen to the received data event stream
      List<int> allEvent = [];
      String serverMsg = '';
      socket.listen((List<int> event) {
        allEvent.addAll(event);

      });
      

      

      // send hello
      String msg = account + ";";
      socket.add(utf8.encode(msg));

      // wait 1.1 seconds
      await Future.delayed(Duration(milliseconds: 1100));

      serverMsg = utf8.decode(allEvent);
      userInfo = serverMsg.split("&");
      name = userInfo[0];
      gender = userInfo[1];
      age = userInfo[2];
      weight = userInfo[3];
      phone = userInfo[4];
      email = userInfo[5];
      address = userInfo[6];
      doctor = userInfo[7].split(';')[0];

      // .. and close the socket
      socket.close();
      nameCon..text = name;
      genderCon..text = gender;
      ageCon..text = age;
      weightCon..text = weight;
      phoneCon..text = phone;
      emailCon..text = email;
      addressCon..text = address;
      doctorCon..text = doctor;

      firstModifyFlag = false;
      if(mounted)
        setState(() {});
    }

    if (firstModifyFlag == true) {
      log('第一次進編輯頁面');
      _loadUserInfo();
    }
    

    //更改userInfo
    _modifyUserInfo(name, gender, age, weight, phone, email,
        address, doctor) async {
      //與server溝通
      Socket socket = await Socket.connect('140.117.168.12', 54544);
      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        print(utf8.decode(event));
      });
      String msg = account +
          "<" +
          name +
          "<" +
          gender +
          "<" +
          age +
          "<" +
          weight +
          "<" +
          phone +
          "<" +
          email +
          "<" +
          address +
          "<" +
          doctor +
          ";";
          print(msg);
      // send hello
      socket.add(utf8.encode(msg));
      // wait 5 seconds
      await Future.delayed(Duration(seconds: 2));
      // .. and close the socket
      socket.close();
    }



    return 
    Listener(
            onPointerDown: (_) => hideKeyboard(),
            child:
    Scaffold(
        body: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.black87,
            width: screenWidth,
            height: screenHeight,
            child: 
            !firstModifyFlag?
            Column(
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: name,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      name.length)))),
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
                                  name = text;
                                  nameCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: gender,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      gender.length)))),
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
                                  gender= text;
                                  genderCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: age,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      age.length)))),
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
                                  age= text;
                                  ageCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: weight,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      weight.length)))),
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
                                  weight= text;
                                  weightCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: phone,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      phone.length)))),
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
                                  phone= text;
                                  phoneCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: email,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      email.length)))),
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
                                  email= text;
                                  emailCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: address,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      address.length)))),
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
                                  address= text;
                                  addressCon..text = text;
                                },
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
                                controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                          // 设置内容
                                          text: doctor,
                                          // 保持光标在最后
                                          selection: TextSelection.fromPosition(
                                              TextPosition(
                                                  affinity:
                                                      TextAffinity.downstream,
                                                  offset:
                                                      doctor.length)))),
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
                                  doctor = text;
                                  doctorCon..text = text;
                                },
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
                          Future.delayed(Duration(milliseconds: 1000), () {
                            Navigator.pop(dialogContext);
                            
                          });

                          //更新userInfo至server
                          await _modifyUserInfo(name, gender, age, weight,
                              phone, email, address, doctor);
                          await _loadUserInfo();
                          //延遲一秒後將AlertDialog pop
                          
                          // 重新從server下載userInfo
                          // _loadUserInfo();
                          // setState(() {});
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
                          Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const Home(),
                          //     maintainState: false,
                          //   ),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ) : Container())));
  }
}

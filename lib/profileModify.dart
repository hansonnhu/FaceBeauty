// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ProfileModify extends StatefulWidget {
  const ProfileModify({Key? key}) : super(key: key);

  @override
  _ProfileModifyState createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
  bool termIsChecked = false;

  @override
  Widget build(BuildContext context) {
    //判斷帳號密碼是否只有盈文或數字
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

    final TextEditingController name = TextEditingController();
    final TextEditingController gender = TextEditingController();
    final TextEditingController age = TextEditingController();
    final TextEditingController weight = TextEditingController();
    final TextEditingController phone = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController address = TextEditingController();
    final TextEditingController doctor = TextEditingController();

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
                                controller: name,
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
                                controller: gender,
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
                                controller: age,
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
                                controller: weight,
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
                                controller: phone,
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
                                controller: email,
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
                                controller: address,
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
                                controller: doctor,
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
                          
                          // log('account: ${account.text}');
                          // log('password: ${password.text}');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}

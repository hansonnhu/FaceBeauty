import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'parameter.dart';
// TextEditingController nameCon = TextEditingController();
// TextEditingController genderCon = TextEditingController();
// TextEditingController ageCon = TextEditingController();
// TextEditingController weightCon = TextEditingController();
// TextEditingController phoneCon = TextEditingController();
// TextEditingController emailCon = TextEditingController();
// TextEditingController addressCon = TextEditingController();
// TextEditingController doctorCon = TextEditingController();

void hideKeyboard() {
  // 按空白處影藏鍵盤
  FocusManager.instance.primaryFocus?.unfocus();
}

class ProfileModify extends StatefulWidget {
  const ProfileModify({Key? key}) : super(key: key);

  @override
  _ProfileModifyState createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
  bool firstModifyFlag = true;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _genderFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
  void dispose() {
    _nameFocus.dispose();
    _genderFocus.dispose();
    _ageFocus.dispose();
    _emailFocus.dispose();
    _nameController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    // 抓取UserInfo
    _loadUserInfo() async {
      print('loading user info');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = (prefs.getString('account') ?? '');

      //與server溝通
      Socket socket = await Socket.connect(serverIP, serverPort);
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      // listen to the received data event stream
      String serverMsg = '';
      socket.listen((List<int> event) async {
        serverMsg = utf8.decode(event);
        // print(serverMsg);
      });

      // String msg = account + "<" + name + "<" + gender + "<" + age + "<" + weight + "<" + phone + "<" + email + "<" + address + "<" + doctor + ";";
      String msg = account + ";";

      // 傳送訊息給server
      var randomNum = Random().nextInt(100000);
      String tempClientNumString = account + ':' + randomNum.toString();
      msg = 'startCode103040023<' +
          tempClientNumString +
          '<' +
          'loadUserInfo' +
          '<' +
          msg;

      print('傳送給server: ' + msg);
      List<int> msgBytes = [];
      msgBytes.addAll(utf8.encode(msg));
      msgBytes.add(0);
      socket.add(msgBytes);

      // wait 0.5 seconds
      while (true) {
        await Future.delayed(Duration(milliseconds: 500));
        if (serverMsg.contains(';')) {
          // 要求server斷線
          // print('要求斷線');
          // String msg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
          // msgBytes = [];
          // msgBytes.addAll(utf8.encode(msg));
          // msgBytes.add(0);
          // socket.add(msgBytes);
          // socket.close();

          serverMsg = serverMsg.split(";")[0];
          userInfo = serverMsg.split("<");
          name = userInfo[0];
          gender = userInfo[1];
          age = userInfo[2];
          // weight = userInfo[3];
          // phone = userInfo[4];
          email = userInfo[3];
          // address = userInfo[6];
          // doctor = userInfo[7].split(';')[0];

          _nameController..text = name;
          _genderController..text = gender;
          _ageController..text = age;
          // weightCon..text = weight;
          // phoneCon..text = phone;
          _emailController..text = email;
          // addressCon..text = address;
          // doctorCon..text = doctor;

          firstModifyFlag = false;
          if (mounted) setState(() {});
          break;
        }
      }
      socket.close();
      // if(mounted)
    }

    //更改userInfo
    _modifyUserInfo(name, gender, age, email) async {
      //與server溝通
      Socket socket = await Socket.connect(serverIP, serverPort);
      print(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        print(utf8.decode(event));
      });

      // String msg = account + "<" + name + "<" + gender + "<" + age + "<" + weight + "<" + phone + "<" + email + "<" + address + "<" + doctor + ";";
      String msg =
          account + "<" + name + "<" + gender + "<" + age + "<" + email + ";";

      // 傳送訊息給server
      var randomNum = Random().nextInt(100000);
      String tempClientNumString = account + ':' + randomNum.toString();
      msg = 'startCode103040023<' +
          tempClientNumString +
          '<' +
          'modifyUserInfo' +
          '<' +
          msg;
      List<int> msgBytes = [];
      msgBytes.addAll(utf8.encode(msg));
      msgBytes.add(0);
      socket.add(msgBytes);

      // wait 2 seconds
      await Future.delayed(Duration(seconds: 2));

      // 要求server斷線
      // String disconnectMsg = 'startCode103040023<' + tempClientNumString + '<' + 'disconnect' + ';';
      // msgBytes = [];
      // msgBytes.addAll(utf8.encode(disconnectMsg));
      // msgBytes.add(0);
      // socket.add(msgBytes);
      // socket.close();
    }

    if (firstModifyFlag == true) {
      print('第一次進編輯頁面');
      _loadUserInfo();
    }

    return Listener(
        onPointerDown: (_) => hideKeyboard(),
        child: Scaffold(
            body: Container(
                padding: const EdgeInsets.all(30),
                color: Colors.black,
                width: screenWidth,
                height: screenHeight,
                child: !firstModifyFlag
                    ? Column(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          controller: _nameController,
                                          focusNode: _nameFocus,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(2),
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
                                            // _nameController..text = text;
                                          },
                                          onTap: () {
                                            if (!_nameFocus.hasFocus) {
                                              _nameFocus.requestFocus();
                                            }
                                            final TextEditingValue value =
                                                _nameController.value;
                                            _nameController.selection =
                                                TextSelection(
                                                    baseOffset: value
                                                        .selection.baseOffset,
                                                    extentOffset: value
                                                        .selection
                                                        .extentOffset);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          controller: _genderController,
                                          focusNode: _genderFocus,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(2),
                                            filled: true,
                                            fillColor: Colors.white70,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              width: 10,
                                              color: Colors.white,
                                            )),
                                          ),
                                          onChanged: (text) {
                                            gender = text;
                                            // _genderController..text = text;
                                          },
                                          onTap: () {
                                            if (!_genderFocus.hasFocus) {
                                              _genderFocus.requestFocus();
                                            }
                                            final TextEditingValue value =
                                                _genderController.value;
                                            _genderController.selection =
                                                TextSelection(
                                                    baseOffset: value
                                                        .selection.baseOffset,
                                                    extentOffset: value
                                                        .selection
                                                        .extentOffset);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          controller: _ageController,
                                          focusNode: _ageFocus,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(2),
                                            filled: true,
                                            fillColor: Colors.white70,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              width: 10,
                                              color: Colors.white,
                                            )),
                                          ),
                                          onChanged: (text) {
                                            age = text;
                                            // _ageController..text = text;
                                          },
                                          onTap: () {
                                            if (!_ageFocus.hasFocus) {
                                              _ageFocus.requestFocus();
                                            }
                                            final TextEditingValue value =
                                                _ageController.value;
                                            _ageController.selection =
                                                TextSelection(
                                                    baseOffset: value
                                                        .selection.baseOffset,
                                                    extentOffset: value
                                                        .selection
                                                        .extentOffset);
                                          },
                                        ))
                                      ],
                                    ),
                                  ),

                                  //體重
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //     top: 10,
                                  //     bottom: 10,
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       const Text(
                                  //         '體重',
                                  //         style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Expanded(
                                  //           child: TextField(
                                  //         controller: TextEditingController.fromValue(
                                  //               TextEditingValue(
                                  //                   // 设置内容
                                  //                   text: weight,
                                  //                   // 保持光标在最后
                                  //                   selection: TextSelection.fromPosition(
                                  //                       TextPosition(
                                  //                           affinity:
                                  //                               TextAffinity.downstream,
                                  //                           offset:
                                  //                               weight.length)))),
                                  //         keyboardType: TextInputType.text,
                                  //         style: const TextStyle(
                                  //           fontSize: 30,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //         decoration: const InputDecoration.collapsed(
                                  //           hintText: '',
                                  //           filled: true,
                                  //           fillColor: Colors.white70,
                                  //           border: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //             width: 10,
                                  //             color: Colors.white,
                                  //           )),
                                  //         ),
                                  //         onChanged: (text) {
                                  //           weight= text;
                                  //           weightCon..text = text;
                                  //         },
                                  //       ))
                                  //     ],
                                  //   ),
                                  // ),

                                  //電話
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //     top: 10,
                                  //     bottom: 10,
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       const Text(
                                  //         '電話',
                                  //         style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Expanded(
                                  //           child: TextField(
                                  //         controller: TextEditingController.fromValue(
                                  //               TextEditingValue(
                                  //                   // 设置内容
                                  //                   text: phone,
                                  //                   // 保持光标在最后
                                  //                   selection: TextSelection.fromPosition(
                                  //                       TextPosition(
                                  //                           affinity:
                                  //                               TextAffinity.downstream,
                                  //                           offset:
                                  //                               phone.length)))),
                                  //         keyboardType: TextInputType.text,
                                  //         style: const TextStyle(
                                  //           fontSize: 30,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //         decoration: const InputDecoration.collapsed(
                                  //           hintText: '',
                                  //           filled: true,
                                  //           fillColor: Colors.white70,
                                  //           border: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //             width: 10,
                                  //             color: Colors.white,
                                  //           )),
                                  //         ),
                                  //         onChanged: (text) {
                                  //           phone= text;
                                  //           phoneCon..text = text;
                                  //         },
                                  //       ))
                                  //     ],
                                  //   ),
                                  // ),

                                  //信箱
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          controller: _emailController,
                                          focusNode: _emailFocus,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(2),
                                            filled: true,
                                            fillColor: Colors.white70,
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              width: 10,
                                              color: Colors.white,
                                            )),
                                          ),
                                          onChanged: (text) {
                                            email = text;
                                            // _emailController..text = text;
                                          },
                                          onTap: () {
                                            if (!_emailFocus.hasFocus) {
                                              _emailFocus.requestFocus();
                                            }
                                            final TextEditingValue value =
                                                _emailController.value;
                                            _emailController.selection =
                                                TextSelection(
                                                    baseOffset: value
                                                        .selection.baseOffset,
                                                    extentOffset: value
                                                        .selection
                                                        .extentOffset);
                                          },
                                        ))
                                      ],
                                    ),
                                  ),

                                  //地址
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //     top: 10,
                                  //     bottom: 10,
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       const Text(
                                  //         '地址',
                                  //         style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Expanded(
                                  //           child: TextField(
                                  //         controller: TextEditingController.fromValue(
                                  //               TextEditingValue(
                                  //                   // 设置内容
                                  //                   text: address,
                                  //                   // 保持光标在最后
                                  //                   selection: TextSelection.fromPosition(
                                  //                       TextPosition(
                                  //                           affinity:
                                  //                               TextAffinity.downstream,
                                  //                           offset:
                                  //                               address.length)))),
                                  //         keyboardType: TextInputType.text,
                                  //         style: const TextStyle(
                                  //           fontSize: 30,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //         decoration: const InputDecoration.collapsed(
                                  //           hintText: '',
                                  //           filled: true,
                                  //           fillColor: Colors.white70,
                                  //           border: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //             width: 10,
                                  //             color: Colors.white,
                                  //           )),
                                  //         ),
                                  //         onChanged: (text) {
                                  //           address= text;
                                  //           addressCon..text = text;
                                  //         },
                                  //       ))
                                  //     ],
                                  //   ),
                                  // ),

                                  //醫師
                                  // Container(
                                  //   padding: const EdgeInsets.only(
                                  //     top: 10,
                                  //     bottom: 10,
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                  //     children: [
                                  //       const Text(
                                  //         '醫師',
                                  //         style: TextStyle(
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Colors.white,
                                  //         ),
                                  //       ),
                                  //       const SizedBox(
                                  //         width: 10,
                                  //       ),
                                  //       Expanded(
                                  //           child: TextField(
                                  //         controller: TextEditingController.fromValue(
                                  //               TextEditingValue(
                                  //                   // 设置内容
                                  //                   text: doctor,
                                  //                   // 保持光标在最后
                                  //                   selection: TextSelection.fromPosition(
                                  //                       TextPosition(
                                  //                           affinity:
                                  //                               TextAffinity.downstream,
                                  //                           offset:
                                  //                               doctor.length)))),
                                  //         keyboardType: TextInputType.text,
                                  //         style: const TextStyle(
                                  //           fontSize: 30,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //         decoration: const InputDecoration.collapsed(
                                  //           hintText: '',
                                  //           filled: true,
                                  //           fillColor: Colors.white70,
                                  //           border: OutlineInputBorder(
                                  //               borderSide: BorderSide(
                                  //             width: 10,
                                  //             color: Colors.white,
                                  //           )),
                                  //         ),
                                  //         onChanged: (text) {
                                  //           doctor = text;
                                  //           doctorCon..text = text;
                                  //         },
                                  //       ))
                                  //     ],
                                  //   ),
                                  // ),
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
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal)),
                                  onPressed: () async {
                                    print('按下完成按鈕');
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
                                    Future.delayed(Duration(milliseconds: 1000),
                                        () {
                                      Navigator.pop(dialogContext);
                                    });

                                    //更新userInfo至server
                                    // await _modifyUserInfo(name, gender, age, weight, phone, email, address, doctor);
                                    await _modifyUserInfo(
                                        name, gender, age, email);
                                    await _loadUserInfo();
                                    //延遲一秒後將AlertDialog pop

                                    // 重新從server下載userInfo
                                    // _loadUserInfo();
                                    // setState(() {});
                                    // print("${myController.text}");
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('取消'),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal)),
                                  onPressed: () {
                                    print('按下取消按鈕');
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
                      )
                    : Container())));
  }
}

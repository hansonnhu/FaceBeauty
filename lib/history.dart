// app的一些設定調整(綁定硬體裝置)
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'upLoading.dart';
import 'parameter.dart';

String account = '';


String userName = ''; //使用者名稱

// List<Uint8List> allOriImgByteString = [];
int oriImgCount = 0;



class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool dataLoadedFlag = false;
  List<String> allDateTimeList = []; //所有 DateTime string
  List<String> allOriImgString = [];  //所有的 oriImg
  List<bool> allOriImgChoose = [];  //所有的 紀錄 是否"已選擇"
  bool allChooseFlag = false; //是否選取所有紀錄
  bool historyEmpty = true; // 歷史紀錄為空，預設為 true

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    
    


    //於資料庫抓取data
    loadData() async {
      print('第一次進 History !');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = prefs.getString('account') ?? '';


      //與server溝通
      Socket socket = await Socket.connect(serverIP, serverPort);
      print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      // listen to the received data event stream
      String serverMsg = '';
      List<int> intListServerMsg = [];
      socket.listen((List<int> event) async {
        intListServerMsg.addAll(event); //server訊息不會一次傳完，須將每次存下來
      });
      
      // 傳送訊息給server
      var randomNum = Random().nextInt(100000);
      String tempClientNumString = account + ':' + randomNum.toString();
      String msg = 'startCode103040023<' + tempClientNumString + '<' + 'returnHistory' + '<' + account + ';';
      List<int> msgBytes = [];
      msgBytes.addAll(utf8.encode(msg));
      msgBytes.add(0);
      socket.add(msgBytes);

      // wait 0.5 seconds
      while(true){
        await Future.delayed(Duration(milliseconds: 100));
        try{
          serverMsg = utf8.decode(intListServerMsg);
        }
        catch(e){
          // print(e);
          continue;
        }
        
        if (serverMsg.contains(';')){
          historyEmpty = false;
          List <String> temp = serverMsg.split('<');
          temp.removeLast();
          for(int i=0; i<temp.length; i++){
            allOriImgString.add(temp[i].split(':')[0]);
            allDateTimeList.add(temp[i].split(':')[1].replaceAll('.', ':'));
            allOriImgChoose.add(false);
          }
          oriImgCount = allDateTimeList.length;
          // print(allDateTimeList);
          socket.close();
          break;
        }
      }
      dataLoadedFlag = true;
      try{
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   _scrollController.jumpTo(0);
        // });

        if (mounted) setState(() {});
      }
      catch(e){
        print(e);
      }
    }

    if (dataLoadedFlag == false) loadData();

    return Scaffold(
        body: Container(
            padding:
                const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
            color: Colors.black,
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: [
                //歷史紀錄
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  const[
                      Text(
                        '歷史紀錄',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(0),
                  alignment:Alignment.centerLeft,
                  child: 
                  // 全選框框
                    CheckboxListTile(
                      controlAffinity:ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,

                      title: const Text(
                        '選擇全部',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      checkColor: Colors.black,
                      activeColor: Colors.grey,
                      side:BorderSide(color: Colors.white),
                      value: allChooseFlag,
                      onChanged: (bool? value) {
                        if (mounted) setState(() {
                          allChooseFlag = value!;
                          for(int i=0; i<allOriImgChoose.length; i++){
                            allOriImgChoose[i] = allChooseFlag;
                          }
                        });
                      },
                    ),
                ),

                //intor text
                Expanded(
                    child: 
                    (dataLoadedFlag == false) ? Center(
                      child: Container(
                        height: 50,
                          child: Image.asset(
                            'assets/laodingGIF.imageset/loading9.gif',
                            fit: BoxFit.fitHeight,
                          )
                      ),
                    ):
                    Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 40,
                        ),
                        child: 
                          (oriImgCount == 0) ? const Text(
                            '目前沒有紀錄',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal,
                            ),
                          ): ListView.builder(
                            padding: new EdgeInsets.only(top: 0, bottom: 0),
                            itemCount: oriImgCount,
                            reverse: false,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () async {
                                    print('選擇 oriImgIndex 為 : ' +
                                        ((oriImgCount - 1) - index).toString());
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('tempImgString', allOriImgString[(oriImgCount - 1) - index]);
                                    await prefs.setString('imgFromHistory', 'true');

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Uploading(),
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
                                              color: Colors.white
                                            )
                                          )
                                        ),
                                    child: Row(
                                      children: [
                                        // checkBox
                                        Expanded(
                                          child: 
                                          Checkbox(
                                            checkColor: Colors.black,
                                            activeColor: Colors.grey,
                                            side: const BorderSide(color: Colors.white),
                                            value: allOriImgChoose[(oriImgCount - 1) - index],
                                            onChanged: (bool? value) {
                                              if (mounted) setState(() {
                                                allOriImgChoose[(oriImgCount - 1) - index] = value!;
                                              });
                                            },
                                          )
                                        ),


                                        // 該筆資料之 oriImg
                                        Expanded(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.memory(
                                              (base64Decode(
                                                  allOriImgString[(oriImgCount - 1) - index])),
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                        ),

                                        // 使用者帳號名稱
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                account,
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
                                                allDateTimeList[(oriImgCount - 1) - index],
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
                            print('按下清除按鈕');

                            // 跳出警示視窗確認user是否真的要刪除所有分析紀錄
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                title: const Text('警告'),
                                content: const Text('確定刪除勾選的分析紀錄?'),
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

                                        //與server溝通
                                        Socket socket = await Socket.connect(serverIP, serverPort);
                                        print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
                                        // listen to the received data event stream
                                        List<int> intListServerMsg = [];
                                        socket.listen((List<int> event) async {
                                          intListServerMsg.addAll(event);
                                        });
                                        

                                        if(allChooseFlag == true){
                                          // 傳送訊息給server
                                          var randomNum = Random().nextInt(100000);
                                          String tempClientNumString = account + ':' + randomNum.toString();
                                          String msg = 'startCode103040023<' + tempClientNumString + '<' + 'deleteHistory' + '<' + account + '<' + '-1' + ';';
                                          List<int> msgBytes = [];
                                          msgBytes.addAll(utf8.encode(msg));
                                          msgBytes.add(0);
                                          socket.add(msgBytes);
                                        }else{
                                          var randomNum = Random().nextInt(100000);
                                          String tempClientNumString = account + ':' + randomNum.toString();
                                          String msg = 'startCode103040023<' + tempClientNumString + '<' + 'deleteHistory' + '<' + account + '<' ;
                                          for(int i=0; i<allOriImgChoose.length; i++){
                                            if(allOriImgChoose[i] == true){
                                              print('delete '+ i.toString());
                                              msg += (i.toString() + '<');
                                            }
                                          }
                                          msg += ';';
                                          print(msg);
                                          // 傳送訊息給server
                                          List<int> msgBytes = [];
                                          msgBytes.addAll(utf8.encode(msg));
                                          msgBytes.add(0);
                                          socket.add(msgBytes);
                                        }
                                        socket.close();
                                        allDateTimeList = [];
                                        allOriImgString = [];
                                        allOriImgChoose = [];
                                        String serverMsg = '';

                                        while(true){
                                          await Future.delayed(Duration(milliseconds: 1000));
                                          try{
                                            serverMsg = utf8.decode(intListServerMsg);
                                          }
                                          catch(e){
                                            // print(e);
                                            continue;
                                          }
                                          if (serverMsg.contains('delete success')){
                                            print('delete success');
                                            await loadData();
                                            socket.close();
                                            break;
                                          }
                                        }
                                        
                                    }
                                  )
                                ],
                              ),
                            );
                            
                            
                          },
                        ),
                        //趨勢按鈕
                        // ElevatedButton(
                        //   child: Text('趨勢'),
                        //   style: ElevatedButton.styleFrom(
                        //       onSurface: Colors.white60,
                        //       primary: Colors.green.shade900,
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 20, vertical: 10),
                        //       textStyle: const TextStyle(
                        //           fontSize: 25, fontWeight: FontWeight.normal)),
                        //   onPressed: () async {
                        //     print('按下趨勢按鈕');
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => AllTrend(),
                        //         maintainState: false,
                        //       ),
                        //     );
                        //   },
                        // ),
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
                            print('按下返回按鈕');
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                )
              ],
            )));
  }
}

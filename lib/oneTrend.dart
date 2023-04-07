// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:facebeauty/home.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'guide.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';

String iniAccount = "";
String iniPassword = "";
String account = '';
int trendIndex = 0;
List<SeriesDatas> serialList = []; // 其中一種折線圖之data
List<String> trendTitleList = [];
double max = -1;
double min = 1000;
double avg = 0; //平均值

class SeriesDatas {
  final int time;
  final double data;
  SeriesDatas(this.time, this.data);
}

class OneTrend extends StatefulWidget {
  const OneTrend({Key? key}) : super(key: key);

  @override
  _OneTrendState createState() => _OneTrendState();
}

class _OneTrendState extends State<OneTrend> {
  bool dataLoadedFlag = false;

  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    

    _loadData()async {
      print('loading data');
      serialList = [];// 重設
      avg = 0; //平均值重設
      max = -1;
      min = 1000;
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      trendIndex = prefs.getInt('trendIndex') ?? 0;
      trendTitleList = prefs.getStringList('trendTitleList') ?? [];
      account = prefs.getString('account') ?? '';
      print(account + '   ' + trendIndex.toString());

      String tempName = 'ratio_'+trendIndex.toString();
      List<String> tempList = prefs.getStringList(account + tempName) ?? [];
      print(tempList);
      for (int i = 0;i<tempList.length;i++){
        if(double.parse(tempList[i]) > max){
          max = double.parse(tempList[i]);
        }
        if(double.parse(tempList[i]) < min){
          min = double.parse(tempList[i]);
        }
        avg += double.parse(tempList[i]);
        serialList.insert(i, SeriesDatas(i, double.parse(tempList[i])));
      }
      avg = avg/tempList.length;
      dataLoadedFlag = true;
      setState(() {});
    }
    if(dataLoadedFlag == false){
      _loadData();
      
    }

    return Scaffold(
        body: 
        dataLoadedFlag == false ? Container(color: Colors.black,):
        Container(
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
                    bottom: 40,
                  ),
                  child: 
                    Text(
                      trendTitleList[trendIndex],
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                      padding:
                          const EdgeInsets.only(
                              left: 10),
                      child: charts.LineChart(
                        [
                          charts.Series< SeriesDatas, int>(
                            id: 'line',
                            colorFn: (_, __) =>
                            charts.MaterialPalette.yellow.shadeDefault,
                            domainFn: (SeriesDatas sales,_) => sales.time,
                            measureFn:(SeriesDatas sales,_) => sales.data,
                            data:serialList,
                          )
                        ],
                        animate: true,
                        defaultRenderer: charts.LineRendererConfig(
                          radiusPx: 5.0,
                          stacked: false,
                          strokeWidthPx: 2.0,
                          includeLine: true,
                          includePoints: true,
                          includeArea: true,
                          areaOpacity: 0.2,
                        ),
                      )
                    )
                  ),

                //intor text
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          Text('最高值  ' + max.toString(),style: const TextStyle(color: Colors.white,fontSize: 18)),
                          Text('最低值  ' + min.toString(),style: const TextStyle(color: Colors.white,fontSize: 18)),
                          Text('平均值  ' + avg.toStringAsFixed(2),style: const TextStyle(color: Colors.white,fontSize: 18)),
                        ],))),

                //繼續按鈕
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 0,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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

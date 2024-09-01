// app的一些設定調整(綁定硬體裝置)
// 料庫中，所有特徵點的趨勢頁面
import 'package:facebeauty/oneTrend.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'oneTrend.dart';
import 'package:charts_flutter/flutter.dart' as charts;

String iniAccount = "";
String iniPassword = "";

String userName = ''; //使用者名稱
List<String> allDateTimeList = []; //所有 DateTime string
String account = '';
List<List<SeriesDatas>> serialList = []; // 34種折線圖之data
List<double> max_ratio_list = []; // 34種折線圖data之最大值
List<double> min_ratio_list = []; // 34種折線圖data之最小值

//下載所有的 oriImg
List<String> allOriImgString = [];
List<Uint8List> allOriImgByteString = [];
int oriImgCount = 0;
List<String> trendTitleList = [];

class SeriesDatas {
  final int time;
  final double data;
  SeriesDatas(this.time, this.data);
}

class AllTrend extends StatefulWidget {
  const AllTrend({Key? key}) : super(key: key);

  @override
  _AllTrendState createState() => _AllTrendState();
}

class _AllTrendState extends State<AllTrend> {
  bool dataLoadedFlag = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    //於資料庫抓取data
    _loadData() async {
      serialList = []; // 重設
      max_ratio_list = []; // 重設
      max_ratio_list = []; // 重設

      print('第一次進 AllTrend !');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      account = prefs.getString('account') ?? '';
      trendTitleList = prefs.getStringList('trendTitleList') ?? [];

      for (int i = 0; i < 34; i++) {
        double max = -1;
        double min = 1000;
        String tempName = 'ratio_' + i.toString();
        List<String> tempList = prefs.getStringList(account + tempName) ?? [];
        // print(tempList);

        List<SeriesDatas> tempSerial = [];
        for (int j = 0; j < tempList.length; j++) {
          if (double.parse(tempList[j]) >= max) {
            max = double.parse(tempList[j]);
          }
          if (double.parse(tempList[j]) < min) {
            min = double.parse(tempList[j]);
          }
          tempSerial.insert(j, SeriesDatas(j, double.parse(tempList[j])));
        }
        max_ratio_list.insert(max_ratio_list.length, max);
        min_ratio_list.insert(min_ratio_list.length, min);
        serialList.insert(i, tempSerial);
      }

      // for(int i=0;i<oriImgCount;i++){
      //   allOriImgByteString[i] = await base64Decode(allOriImgString[i]);
      // }

      dataLoadedFlag = true;
      if (mounted) setState(() {});
    }

    if (dataLoadedFlag == false) _loadData();

    return Scaffold(
        body: dataLoadedFlag == false
            ? Container()
            : Container(
                padding: const EdgeInsets.only(
                    top: 30, bottom: 30, left: 10, right: 10),
                color: Colors.black,
                width: screenWidth,
                height: screenHeight,
                child: Column(
                  children: [
                    //趨勢
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '趨勢',
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
                        child: Container(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: ListView.builder(
                                padding: new EdgeInsets.only(top: 0, bottom: 0),
                                itemCount: trendTitleList.length,
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () async {
                                        print('選擇 trendIndex 為 : ' +
                                            index.toString());
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setInt('trendIndex', index);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OneTrend(),
                                            maintainState: false,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        height: 80,
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.brown))),
                                        child: Row(
                                          children: [
                                            //trendTtile
                                            Expanded(
                                                flex: 4,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(left: 10),
                                                  child: Text(
                                                      trendTitleList[index],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18)),
                                                )),
                                            //line chart
                                            Expanded(
                                                flex: 4,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: charts.LineChart(
                                                      [
                                                        charts.Series<
                                                            SeriesDatas, int>(
                                                          id: 'line' +
                                                              index.toString(),
                                                          colorFn: (_, __) =>
                                                              charts
                                                                  .MaterialPalette
                                                                  .yellow
                                                                  .shadeDefault,
                                                          domainFn: (SeriesDatas
                                                                      sales,
                                                                  _) =>
                                                              sales.time,
                                                          measureFn:
                                                              (SeriesDatas
                                                                          sales,
                                                                      _) =>
                                                                  sales.data,
                                                          data:
                                                              serialList[index],
                                                        )
                                                      ],
                                                      animate: true,
                                                      defaultRenderer: charts
                                                          .LineRendererConfig(
                                                        radiusPx: 2.0,
                                                        stacked: false,
                                                        strokeWidthPx: 2.0,
                                                        includeLine: true,
                                                        includePoints: true,
                                                        includeArea: true,
                                                        areaOpacity: 0.2,
                                                      ),
                                                    ))),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                            max_ratio_list[
                                                                    index]
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18)),
                                                        Text(
                                                            min_ratio_list[
                                                                    index]
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18)),
                                                      ],
                                                    ))),
                                          ],
                                        ),
                                      ),
                                    )))),

                    //按鈕
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 0,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //返回按鈕
                            ElevatedButton(
                              child: Text('返回'),
                              style: ElevatedButton.styleFrom(
                                  onSurface: Colors.white60,
                                  primary: Colors.teal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  textStyle: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.normal)),
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

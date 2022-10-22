// app的一些設定調整(綁定硬體裝置)
import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AnalysisAnimation extends StatefulWidget {
  const AnalysisAnimation({Key? key}) : super(key: key);

  @override
  _AnalysisAnimationState createState() => _AnalysisAnimationState();
}

class _AnalysisAnimationState extends State<AnalysisAnimation> {
  bool isFirstLoad = true;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return WillPopScope(
        onWillPop: () async => false,
        child: MediaQuery.removePadding(
            removeTop: true,
            removeBottom: true,
            context: context,
            child: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Image.asset(
                    "assets/analysisGIF.imageset/analysisGIF.gif",
                    fit: BoxFit.cover,
                  )),
                  Image.asset(
                    "assets/laodingGIF.imageset/loading_0_to_100.gif",
                    height: screenHeight,
                  ),
                ],
              ),
            )));
  }
}

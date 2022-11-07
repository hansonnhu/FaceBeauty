// 前後鏡頭畫面
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'previewPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee/marquee.dart';
import 'dart:math';


class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription>? cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  

  @override
  void dispose() {
    // _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      await _cameraController.lockCaptureOrientation();
      XFile picture = await _cameraController.takePicture();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    picture: picture,
                    type: 'camera',
                    cameraNum: _isRearCameraSelected ? 0 : 1,
                    cameraCorrectionFlag: cameraCorrectionFlag,
                  )));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) async{
        if (!mounted) return;
        await _cameraController.lockCaptureOrientation();
        await _cameraController.initialize();

        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
  var cameraCorrectionFlag = 0;
  bool flagLoaded = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    void getCameraCorrectionFlag()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cameraCorrectionFlag = prefs.getInt('cameraCorrectionFlag')??1;
      flagLoaded == true;
    }
    if(flagLoaded == false){
      getCameraCorrectionFlag();
    }
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
              (cameraCorrectionFlag == 0)?
              Container():
              Stack(
                children: [
                  Container(
                    // color:Colors.white,
                    // padding: EdgeInsets.only(top: screenHeight/5),
                    child: 
                      Center(
                        child: ClipRRect(
                          child:Image.asset(
                            // 'assets/face_3.imageset/face_3@3x.png',
                            'assets/face_3.imageset/face.png',
                            fit: BoxFit.fill,
                            width: screenWidth,
                            color: Color.fromRGBO(255, 255, 255, 0.4),
                            colorBlendMode: BlendMode.modulate,
                          ), 
                        ),
                      ),
                    
                  ),
                  
                  Container(
                    // padding: EdgeInsets.only(top: screenHeight/5),
                    child: 
                    Center(
                      child: ClipRRect(
                          child:Image.asset('assets/scanningGIF.imageset/scan.gif',
                          fit: BoxFit.fill,
                          width: screenWidth,
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          // colorBlendMode: BlendMode.modulate,
                        ), 
                      ),
                    )
                  ),
                  Container(
                    // padding: EdgeInsets.only(top: screenHeight*4/5),
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    height: screenHeight,
                    width: screenWidth/4,
                    padding: new EdgeInsets.only(left: 5),
                    child: 
                    Marquee(
                      text:'偵測左眼座標: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '眼睛－－－已偵測' + '\n'
                            '分析該區域數值: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '眼睛－－－已偵測' + '\n'
                            '偵測右眼座標: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '眉毛－－－已偵測' + '\n'
                            '分析該區域數值: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '偵測左眉毛座標: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '眉毛－－－已偵測' + '\n'
                            '分析該區域數值: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '偵測右眉毛座標: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '分析該區域數值: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '鼻子－－－已偵測' + '\n'
                            '偵測鼻翼座標: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '分析該區域數值: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '嘴巴－－－已偵測' + '\n'
                            '偵測嘴唇座標: ' + (Random().nextDouble()*10000).toString() + '\n'
                            '分析該區域數值: ' + (Random().nextDouble()*10000).toString() + '\n'
                      ,
                      style: const TextStyle(fontWeight: FontWeight.normal, color:Colors.white, fontSize: 15, ),
                      scrollAxis: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      velocity: 150.0,
                      // pauseAfterRound: Duration(milliseconds: 500),
                      startPadding: 0.0,
                      // accelerationDuration: Duration(seconds: 1),
                      // accelerationCurve: Curves.linear,
                      // decelerationDuration: Duration(milliseconds: 500),
                      // decelerationCurve: Curves.easeOut,
                      )
                  ),

                ],
              ),
              
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                  color: Colors.black),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRearCameraSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                )),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.circle, color: Colors.white),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }
}


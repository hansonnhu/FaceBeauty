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

// 橢圓形畫面class
class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final center = rect.center;
    final radiusX = rect.width * 0.8;
    final radiusY = rect.height * 0.55;
    path.addOval(Rect.fromCenter(center: center, width: radiusX, height: radiusY));
    path.addRect(rect);
    return path..fillType = PathFillType.evenOdd;

  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _CameraScreenState extends State<CameraScreen> 
  with SingleTickerProviderStateMixin{
    late CameraController _cameraController;
    bool _isRearCameraSelected = true;
    late AnimationController _controller;
    late Animation<Offset> _animation;
  

  @override
  void dispose() {
    // _cameraController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![1]);

    // 設置動畫控制器
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // 設置動畫
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, 1),
    ).animate(_controller);
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
      // 若是前鏡頭，則取消鏡像
      // 胡勝清
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
        body: Container(
          height: screenHeight,
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
                  ClipPath(
                    clipper: MyCustomClipper(),
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                      width: screenWidth,
                      height: screenHeight,
                    ),
                  ),
                  
                  // 掃描光束
                  Container(
                    width: double.infinity,
                    height: screenHeight*0.92,
                    // color: Color.fromARGB(255, 247, 217, 76),
                    child: SlideTransition(
                      position: _animation,
                      child: Container(
                        width: double.infinity,
                        height: 4.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color.fromARGB(255, 247, 217, 76), width: 2.0,)
                          ),
                        ),
                      ),
                    ),
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
                      startPadding: 0.0,
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
                    initCamera(widget.cameras![_isRearCameraSelected ? 1 : 0]);
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


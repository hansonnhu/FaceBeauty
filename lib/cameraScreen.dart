// import 'dart:math';

// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'guide.dart';
import 'package:camera/camera.dart';
import 'register.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'previewPage.dart';
import 'package:flutter/cupertino.dart';
// import 'package:image/image.dart' as img;

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
    _cameraController.dispose();
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
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
              Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: 
                    ClipRRect(
                      child:Image.asset('assets/face_3.imageset/face_3@3x.png',
                      fit: BoxFit.cover,
                      width: screenWidth -12), 
                    )
                    
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

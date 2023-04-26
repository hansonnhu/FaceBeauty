import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _opacityController,
        curve: Curves.easeInOut,
      ),
    );
    _opacityController.repeat(reverse: true);

    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => Login(),
      //     maintainState: false,
          
      //   ),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Login()),
      ).then((value) => setState(() {
        // Do any initialization here
        initState();
      }));
    });
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //抓取螢幕寬度
    double screenHeight = MediaQuery.of(context).size.height; //抓取螢幕高度

    return Center(
      child: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Column(
          children: [
            Expanded(flex: 3, child: Container()),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                child: Image.asset(
                  'assets/iconv3.png',
                  width: screenWidth / 2,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                child: const Text(
                  '傾國',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
            
            Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );
  }
}

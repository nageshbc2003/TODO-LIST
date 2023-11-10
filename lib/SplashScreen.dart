import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sampleoftodolist/Home_page.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState(){
    super.initState();
    // Start the timer
    Timer(Duration(seconds: 5), () {

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return HomePage();
        },
      ), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white54,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage("images/345.png",
              ),

            ),

          ),
          Container(
            child: Text('WELCOME',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              wordSpacing: 100.0,
            ),),
          )
        ],
      ),





    );
  }
}
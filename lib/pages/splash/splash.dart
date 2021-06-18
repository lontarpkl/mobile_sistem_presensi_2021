import 'package:flutter/material.dart';
import 'dart:async';

class SplashPages extends StatefulWidget {
  @override
  _SplashPagesState createState() {
    return _SplashPagesState();
  }
}

class _SplashPagesState extends State<SplashPages> {
  startTimer() async {
    var _time = Duration(seconds: 2);
    return Timer(_time, toHome);
  }

  void toHome() {
    Navigator.of(context).pushReplacementNamed('/views');
  }

  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.0,
                        child: Icon(
                          Icons.card_membership,
                          size: 50.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Aplikasi Presensi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Version 1.0",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

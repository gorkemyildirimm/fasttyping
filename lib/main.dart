// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  int typedCharLenght = 0;
  String lorem =
      '                        Did shy say mention enabled through elderly improve. As at so believe account evening behaved hearted is. House is tiled we aware. It ye greatest removing concerns an overcame appetite. Manner result square father boy behind its his. Their above spoke match ye mr right oh as first. Be my depending to believing perfectly concealed household. Point could to built no hours smile sense.Full he none no side. Uncommonly surrounded considered for him are its. It we is read good soon. My to considered delightful invitation announcing of no decisively boisterous. Did add dashwoods deficient man concluded additions resources. Or landlord packages overcame distance smallest in recurred. Wrong maids or be asked no on enjoy. Household few sometimes out attending described. Lain just fact four of am meet high.'
          .replaceAll(',', ' ')
          .replaceAll('.', ' ')
          .toLowerCase();

  int step = 0; // 0 1 conditional ifadelere girme sayacı
  int score = 0; // oyuncunun skor sayacı
  int? lastTypeAt;

  void resetGame() {
    setState(() {
      typedCharLenght = 0;
      step = 0;
    });
  }

  void updateLastTypedAt() {
    this.lastTypeAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();

    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typedCharLenght = value.length;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      this.userName = value;
      //print(userName);
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });
    Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      setState(() {
        if (step == 1 && now - lastTypeAt! > 4000) {
          // 4 sn basmama game over kuralı
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;
    if (step == 0) {
      shownWidget = <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
              autofocus: true,
              onChanged: onUserNameType,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.arrow_forward_ios),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange)),
                labelText: 'Welcome ',
                labelStyle: TextStyle(fontSize: 24),
                hintText: "Please Enter your Username",
                hintStyle: TextStyle(fontSize: 20),
              )),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Container(
            child: ElevatedButton(
          onPressed: userName.length == 0
              ? null
              : onStartClick, // username 0 karakterse oyuna baslayamaz
          child: Text(
            "Start !",
            style: TextStyle(fontSize: 24),
          ),
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(160, 80), primary: Colors.deepOrange),
        ))
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text(
          '$typedCharLenght',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          height: 30,
          child: Marquee(
            text: lorem,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 1.25),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 120,
            startPadding: 0,
            accelerationDuration: Duration(seconds: 15),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, top: 32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.arrow_forward_ios),
              border: OutlineInputBorder(),
              //labelText: 'Type for Start',
              // labelStyle: TextStyle(fontSize: 24)
              hintText: 'Type for Start...',
              hintStyle: TextStyle(fontSize: 20),
            ),
          ),
        )
      ];
    } else {
      shownWidget = <Widget>[
        Text(
          "Game Over , Your Score : $typedCharLenght ",
          style: TextStyle(fontSize: 24),
        ),
        ElevatedButton(
            onPressed: resetGame,
            child: Text(
              "Try Again :)",
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(160, 80), primary: Colors.deepOrange))
      ];
    }

    // TODO: implement build
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Fast Fingers'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flappy_me/Me.dart';
import 'package:flappy_me/barriers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    init();
  }
  List<MyBarrier> barriers;
  double meYaxis = 0;
  double initialHeight = 0;
  bool gameStarted = false;
  double time = 0;
  int score = 0;
  int highScore = 0;
  double speed = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = meYaxis;
    });
  }

  void init() {
    meYaxis = 0;
    initialHeight = meYaxis;
    gameStarted = false;
    barriers = [
      MyBarrier(size: 160.0, xPos: 0.6, yPos: 1.1),
      MyBarrier(size: 160.0, xPos: 0.6, yPos: -1.1),
      MyBarrier(size: 210.0, xPos: 2.4, yPos: 1.1),
      MyBarrier(size: 160.0, xPos: 2.4, yPos: -1.1),
    ];
  }

  void updateBarrier(MyBarrier barrier) {
    if (barrier.x < -2) {
      barrier.setX(1.4);
      score += 1;
      speed += 0.005;
    } else {
      barrier.setX(barrier.x - 0.05 + speed);
    }
  }

  bool isBarrierInCenter(MyBarrier barrier) =>
      -0.4 < barrier.x && barrier.x < 0.4;

  void startGame() {
    gameStarted = true;
    speed = 0;
    time = 0;
    Timer.periodic(Duration(milliseconds: 55), (timer) {
      time += 0.05;
      double height = -4.9 * time * time + 2.8 * time;

      // Actualiza la posicion X de cada barra
      for (MyBarrier barrier in barriers) {
        updateBarrier(barrier);
      }

      if (meYaxis > 1) {
        _gameOver(timer);
      }

      if (isBarrierInCenter(barriers[0])) {
        // podemos checar 0 o 1 (xOne)
        if (meYaxis < -0.44 || meYaxis > 0.44) {
          _gameOver(timer);
        }
      }

      if (isBarrierInCenter(barriers[2])) {
        // podemos checar 2 o 3 (xTwo);
        if (meYaxis < -0.63 || meYaxis > 0.19) {
          _gameOver(timer);
        }
      }
      setState(() => meYaxis = initialHeight - height);
    });
  }

  Future<void> _gameOver(Timer timer) async {
    timer.cancel();
    gameStarted = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[200],
          title: Text(
            'GAME OVER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              wordSpacing: 2.0,
            ),
          ),
          titlePadding: EdgeInsets.all(20.0),
          content: Text(
            'SCORE: ' + score.toString(),
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          actions: [
            FlatButton(
              color: Colors.blue[700],
              child: Text(
                'PLAY AGAIN',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (score > highScore) {
                  highScore = score;
                }
                // initState();
                setState(() {
                  gameStarted = false;
                  init();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        if (gameStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Stack(
              children: <Widget>[
                AnimatedContainer(
                  alignment: Alignment(0, meYaxis),
                  duration: Duration(milliseconds: 0),
                  color: Colors.blue,
                  child: MeEmoji(),
                ),
                Container(
                    alignment: Alignment(0, -0.32),
                    child: gameStarted
                        ? Text('')
                        : Text(
                            'TAP TO PLAY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )),
                AnimatedContainer(
                  alignment: Alignment(barriers[0].x, barriers[0].y),
                  duration: Duration(milliseconds: 0),
                  child: barriers[0],
                ),
                AnimatedContainer(
                  alignment: Alignment(barriers[1].x, barriers[1].y),
                  duration: Duration(milliseconds: 0),
                  child: barriers[1],
                ),
                AnimatedContainer(
                    alignment: Alignment(barriers[2].x, barriers[2].y),
                    duration: Duration(milliseconds: 0),
                    child: barriers[2]),
                AnimatedContainer(
                  alignment: Alignment(barriers[3].x, barriers[3].y),
                  duration: Duration(milliseconds: 0),
                  child: barriers[3],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.green,
            height: 18,
          ),
          Expanded(
            child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'SCORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        score.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'BEST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        highScore.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

import 'dart:async';
import 'package:flappy_me/Me.dart';
import 'package:flappy_me/barriers.dart';
import 'package:flappy_me/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
static double meYaxis = 0;
double height = 0;
double time = 0;
double initialHeight = meYaxis;
bool gameStarted = false;
static double barXone= 0.6;
double barXtwo= barXone + 1.8;
int score = 0;
int highScore = 0;

  void jump() {
    setState(() {
      time = 0;
      initialHeight = meYaxis;
    });
  }

  void startGame(){
    gameStarted = true;
    double speed = 0;
    Timer.periodic(Duration(milliseconds: 55), (timer) {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        meYaxis = initialHeight - height;
      });

      if(barXone < -2){
        barXone += 3.4;
        score +=1;
        speed +=  0.005;
      } else {
        barXone -= 0.05 + speed ;
      }
      if(barXtwo < -2){
        barXtwo += 3.4;
        score +=1;
        speed += 0.005;
      } else {
        barXtwo -= 0.05 + speed ;
      }

      if(meYaxis > 1){
        timer.cancel();
        gameStarted = false;
        _gameOver();
      }

      if(barXtwo < 0.4 && barXtwo > -0.4){
        if(meYaxis < -0.63){
          timer.cancel();
          gameStarted = false;
          _gameOver();
        } else if (meYaxis > 0.19){
          timer.cancel();
          gameStarted = false;
          _gameOver();
        }
      }

      if(barXone < 0.4 && barXone > -0.4){
        if(meYaxis < -0.44){
          timer.cancel();
          gameStarted = false;
          _gameOver();

        } else if (meYaxis > 0.44){
          timer.cancel();
          gameStarted = false;
          _gameOver();
        }
      }
    });
  }

Future<void> _gameOver() async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.blue[200],
        title: Text('GAME OVER',
          style: TextStyle(color: Colors.white,
            fontSize: 30,
            wordSpacing: 2.0,
          ),
        ),
        titlePadding:EdgeInsets.all(20.0),
        content: Text('SCORE: ' + score.toString(),
          style: TextStyle(
            fontSize: 20,
          ),),
        actions:[
          FlatButton(
            color: Colors.blue[700],
            child: Text('PLAY AGAIN',
              style: TextStyle(color: Colors.white),),
            onPressed: () {
              if(score > highScore){
                highScore = score;
              }
              // initState();
              setState(() {
                gameStarted = false;
                meYaxis = 0;
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
        onTap: (){
          if(gameStarted){
            jump();
          }else{
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
                    alignment: Alignment(0,meYaxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: MeEmoji(),
                  ),
                  Container(
                    alignment: Alignment(0,-0.32),
                    child: gameStarted
                        ? Text('')
                        : Text('TAP TO PLAY',
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 20,
                        ),
                    )
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barXone,1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 160.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barXone,-1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 160.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barXtwo,1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 210.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barXtwo,-1.1),
                    duration: Duration(milliseconds: 0),
                    child: MyBarrier(
                      size: 120.0,
                    ),
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
                        Text('SCORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        ),
                        Text( score.toString(),
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
                        Text('BEST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(highScore.toString(),
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
      )
    );
  }
}

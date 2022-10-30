import 'dart:async';
import 'package:bg4102_software/Utilities/customDrawer.dart';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:bg4102_software/constats/routes.dart';
import 'package:flutter/material.dart';
import '../Utilities/button.dart';
import '../Utilities/customAppbar.dart';
import '../Utilities/pixel.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  int numberOfSquares = 120;
  List<int> piece = [];
  var direction = "left";
  List<int> landed = [100000];
  int level = 0;
  bool _isPlaying = false, _gameOver = false;
  int tryCounter = 0;

  bool _isGameStart = false;
  void startGame() {
    _isGameStart = true;
    _isPlaying = true;
    level = 0;
    landed = [100000];
    piece = [
      numberOfSquares - 4 - level * 10,
      numberOfSquares - 3 - level * 10,
      numberOfSquares - 2 - level * 10,
      numberOfSquares - 1 - level * 10
    ];

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (checkWinner()) {
        _isPlaying = false;
        _isGameStart = false;
        _showDialog();
        timer.cancel();
      }

      if (_gameOver && tryCounter == 0) {
        _gameOver = false;
        _isPlaying = false;
        _isGameStart = false;
        _restartDialog();
        timer.cancel();
        tryCounter += 1;
      } else if (_gameOver && tryCounter == 1) {
        _gameOver = false;
        _isPlaying = false;
        _isGameStart = false;
        _notSoberDialog();
        timer.cancel();
        tryCounter = 0;
      }

      if (piece.first % 10 == 0) {
        direction = "right";
      } else if (piece.last % 10 == 9) {
        direction = "left";
      }

      setState(() {
        if (direction == "right") {
          for (int i = 0; i < piece.length; i++) {
            piece[i] += 1;
          }
        } else {
          for (int i = 0; i < piece.length; i++) {
            piece[i] -= 1;
          }
        }
      });
    });
  }

  bool checkWinner() {
    if (landed.last < 10) {
      return true;
    } else {
      return false;
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("You are sober!"),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              )
            ],
          );
        });
  }

  void _restartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: InkWell(
            onTap: () {
              startGame();
              Navigator.of(context).pop();
            },
            child: const Text("Try again"),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  void _notSoberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: InkWell(
            onTap: () {
              startGame();
              Navigator.of(context).pop();
            },
            child: const Text("You should not be driving."),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  void stack() {
    level++;
    if (_isGameStart == true) {
      setState(
        () {
          for (int i = 0; i < piece.length; i++) {
            landed.add(piece[i]);
          }
          if (level < 2) {
            piece = [
              numberOfSquares - 4 - level * 10,
              numberOfSquares - 3 - level * 10,
              numberOfSquares - 2 - level * 10,
              numberOfSquares - 1 - level * 10
            ];
          } else if (level >= 2 && level < 7) {
            piece = [
              numberOfSquares - 3 - level * 10,
              numberOfSquares - 2 - level * 10,
              numberOfSquares - 1 - level * 10
            ];
          } else if (level >= 7) {
            piece = [
              numberOfSquares - 2 - level * 10,
              numberOfSquares - 1 - level * 10
            ];
          }
          checkStack();
        },
      );
    }
  }

  void checkStack() {
    List<int> removed = [];
    setState(() {
      for (int i = 0; i < landed.length; i++) {
        if (!landed.contains(landed[i] + 10) &&
            (landed[i] + 10) < numberOfSquares - 1) {
          removed.add(landed[i]);
          landed.remove(landed[i]);
        }
      }
      for (int i = 0; i < landed.length; i++) {
        if (!landed.contains(landed[i] + 10) &&
            (landed[i] + 10) < numberOfSquares - 1) {
          removed.add(landed[i]);
          landed.remove(landed[i]);
        }
      }
      if (removed.length == piece.length) {
        _gameOver = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        title: 'STACK IT !',
        fontSize: 25,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pushNamed(testResultRoute);
            },
          ),
        ],
        leading: null,
      ),
      body: Container(
        height: SizeConfig.blockSizeVertical,
        // color: Color,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GridView.builder(
                  itemCount: numberOfSquares,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10),
                  itemBuilder: (BuildContext context, int index) {
                    if (piece.contains(index)) {
                      return const MyPixel(
                        color: Color.fromARGB(255, 33, 226, 243),
                      );
                    } else if (landed.contains(index)) {
                      return const MyPixel(
                        color: Color.fromARGB(255, 33, 226, 243),
                      );
                    } else {
                      return MyPixel(
                        color: Colors.grey[400],
                      );
                    }
                  }),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5),
                child: ListView(
                  // physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MyButton(
                      function: !_isPlaying ? startGame : () {},
                      child: const Text(
                        "S T A R T",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    MyButton(
                      function: stack,
                      child: const Text(
                        "S T A C K",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    MyButton(
                      function: () {
                        Navigator.of(context).pushNamed(homePageRoute);
                      },
                      child: const Text(
                        "H O M E",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

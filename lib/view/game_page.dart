import 'dart:async';
import 'package:bg4102_software/Utilities/sizeConfiguration.dart';
import 'package:flutter/material.dart';
import '../Utilities/button.dart';
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

  void startGame() {
    _isPlaying = true;
    level = 0;
    landed = [100000];
    piece = [
      numberOfSquares - 3 - level * 10,
      numberOfSquares - 2 - level * 10,
      numberOfSquares - 1 - level * 10
    ];

    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (checkWinner()) {
        _isPlaying = false;
        _showDialog();
        timer.cancel();
      }

      if (_gameOver) {
        _gameOver = false;
        _isPlaying = false;
        _restartDialog();
        timer.cancel();
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
          return const AlertDialog(
            title: Text("Winner!"),
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
              child: const Text("Restart!"),
            ),
          );
        });
  }

  void stack() {
    level++;
    setState(() {
      for (int i = 0; i < piece.length; i++) {
        landed.add(piece[i]);
      }

      if (level < 4) {
        piece = [
          numberOfSquares - 3 - level * 10,
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10
        ];
      } else if (level >= 4 && level < 8) {
        piece = [
          numberOfSquares - 2 - level * 10,
          numberOfSquares - 1 - level * 10
        ];
      } else if (level >= 8) {
        piece = [numberOfSquares - 1 - level * 10];
      }

      checkStack();
    });
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
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: SizeConfig.blockSizeVertical * 80,
              width: SizeConfig.blockSizeHorizontal * 100,
              // color: Colors.amber,
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
                      Navigator.of(context).pop();
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
    );
  }
}

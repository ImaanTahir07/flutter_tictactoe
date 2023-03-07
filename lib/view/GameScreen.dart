import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tictactoe/res/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int attempts = 0;
  static const maxseconds = 30;
  int seconds = maxseconds;
  Timer? timer;
  List<int> MatchedIndexes = [];
  bool winnerFound = false;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultdeclaration = "";
  bool oTurn = true;
  List<String> displayElements = ["", "", "", "", "", "", "", "", ""];

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _resetTimer();
    timer?.cancel();
  }

  void _resetTimer() {
    seconds = maxseconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: MyColors.primaryColor,
      backgroundColor: Color(0xfff1e1cc),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 30,
                          width: 175,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Color(0xfff1e1cc),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(4, 4),
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 3),
                                BoxShadow(
                                    offset: Offset(-4, -4),
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 3),
                              ]),
                          child: Center(
                            child: Text("ScoreBoard",
                                style: GoogleFonts.aboreto(
                                    color: MyColors.secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset("assets/images/boy.png"),
                                ),
                                Text("Player X:",
                                    style: GoogleFonts.aBeeZee(
                                        color: MyColors.secondaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold)),
                                Text(xScore.toString(),
                                    style: GoogleFonts.aBeeZee(
                                        color: MyColors.secondaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                      "assets/images/woman (1).png"),
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                ),
                                Text("Player ♡:",
                                    style: GoogleFonts.aBeeZee(
                                        color: MyColors.secondaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900)),
                                Text(oScore.toString(),
                                    style: GoogleFonts.aBeeZee(
                                        color: MyColors.secondaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ],
                        )
                      ],
                    )),
                SizedBox(
                  height: 25,
                ),
                Expanded(
                    flex: 3,
                    child: GridView.builder(
                      itemCount: displayElements.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _tapped(index);
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                displayElements[index],
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 54,
                                    color: displayElements[index] == "X"
                                        ? MyColors.secondaryColor
                                        : Colors.pink,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: MatchedIndexes.contains(index)
                                    ? Colors.pink.shade200
                                    : MyColors.secondaryColor.withOpacity(0.3)),
                          ),
                        );
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.pink.shade100,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              resultdeclaration,
                              style: GoogleFonts.aBeeZee(
                                  color: MyColors.secondaryColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        _buildTimer()
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer?.isActive;
    if (isRunning == true) {
      setState(() {
        if (oTurn && displayElements[index] == "") {
          displayElements[index] = "♡";
          filledBoxes++;
        } else if (!oTurn && displayElements[index] == "") {
          displayElements[index] = 'X';
          filledBoxes++;
        }
        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    //row 1
    if (displayElements[0] == displayElements[1] &&
        displayElements[0] == displayElements[2] &&
        displayElements[0] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[0]}" + " Wins!";
        MatchedIndexes.addAll([0, 1, 2]);
        _stopTimer();
        _updateScore(displayElements[0]);
      });
    }
    //row 2
    if (displayElements[3] == displayElements[4] &&
        displayElements[3] == displayElements[5] &&
        displayElements[3] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[3]}" + " Wins!";
        MatchedIndexes.addAll([3, 4, 5]);
        _stopTimer();
        _updateScore(displayElements[3]);
      });
    }
    // row 3
    if (displayElements[6] == displayElements[7] &&
        displayElements[6] == displayElements[8] &&
        displayElements[6] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[6]}" + " Wins!";
        MatchedIndexes.addAll([6, 7, 8]);
        _stopTimer();
        _updateScore(displayElements[6]);
      });
    }
    //col 1
    if (displayElements[0] == displayElements[3] &&
        displayElements[0] == displayElements[6] &&
        displayElements[0] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[0]}" + " Wins!";
        MatchedIndexes.addAll([0, 3, 6]);
        _stopTimer();
        _updateScore(displayElements[0]);
      });
    }
    // col 2
    if (displayElements[1] == displayElements[4] &&
        displayElements[1] == displayElements[7] &&
        displayElements[1] != "") {
      setState(() {
        resultdeclaration = "Player" + "${displayElements[1]}" + " Wins!";
        MatchedIndexes.addAll([1, 4, 7]);
        _stopTimer();
        _updateScore(displayElements[1]);
      });
    }
    // col 3
    if (displayElements[2] == displayElements[5] &&
        displayElements[2] == displayElements[8] &&
        displayElements[2] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[2]}" + " Wins!";
        MatchedIndexes.addAll([2, 5, 8]);
        _stopTimer();
        _updateScore(displayElements[2]);
      });
    }
    // diagonal
    if (displayElements[0] == displayElements[4] &&
        displayElements[0] == displayElements[8] &&
        displayElements[0] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[0]}" + " Wins!";
        MatchedIndexes.addAll([0, 4, 8]);
        _stopTimer();
        _updateScore(displayElements[0]);
      });
    }
    // diagonal
    if (displayElements[2] == displayElements[4] &&
        displayElements[2] == displayElements[6] &&
        displayElements[2] != "") {
      setState(() {
        resultdeclaration = "Player " + "${displayElements[2]}" + " Wins!";
        MatchedIndexes.addAll([2, 4, 6]);
        _stopTimer();
        _updateScore(displayElements[2]);
      });
    }
    if (!winnerFound && filledBoxes == 9) {
      setState(() {
        resultdeclaration = "Game Tied";

        // _ShowDialogBox("Game Tied");
        // _stopTimer();
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == '♡') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayElements[i] = "";
      }
      resultdeclaration = '';
      MatchedIndexes = [];
    });
    filledBoxes = 0;
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer?.isActive;
    return isRunning == true
        ? SizedBox(
            height: 70,
            width: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 1 - seconds / maxseconds,
                  valueColor: AlwaysStoppedAnimation(MyColors.secondaryColor),
                  strokeWidth: 8,
                  backgroundColor: Colors.pink,
                ),
                Center(
                  child: Text('$seconds',
                      style: GoogleFonts.aBeeZee(
                          color: MyColors.secondaryColor.withOpacity(0.5),
                          fontSize: 30,
                          fontWeight: FontWeight.w800)),
                )
              ],
            ),
          )
        : ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              _startTimer();
              _clearBoard();
              attempts++;
            },
            child: Text(attempts == 0 ? "Start" : "Play Again",
                style: GoogleFonts.aBeeZee(
                    color: MyColors.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)));
  }
}

import 'package:flutter/material.dart';
import 'game_state.dart';

main() => runApp(ConnectFourApp());

class ConnectFourApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConnectFourWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConnectFourWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.redo),
      ),
      appBar: AppBar(
        title: Center(
          child: Text(
            'Connect Four',
          ),
        ),
      ),
      body: ConnectFourGameWidget(),
    );
  }
}

class ConnectFourGameWidget extends StatefulWidget {
  @override
  _ConnectFourGameWidgetState createState() => _ConnectFourGameWidgetState();
}

class _ConnectFourGameWidgetState extends State<ConnectFourGameWidget> {
  final GameState state = GameState();
  int _currentRound = 0;
  String _gameText = "Player one has to make a move...";
  bool _won = false;

  resetGame() {
    _won = false;
    _currentRound = 0;
    _gameText = "Player one has to make a move...";
    state.reset();
  }

  Color _mapStringToColor(String str) {
    switch (str) {
      case GameState.playerOne:
        return Colors.yellow;
      case GameState.playerTwo:
        return Colors.red;
      default:
        return Colors.lightBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.yellow,
          child: Text(
            _gameText,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.blue,
            child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: GameState.width,
                children: state.getBoardContent().map<Widget>((boardCell) {
                  return GestureDetector(
                    onTap: () {
                      if (_won) {
                        return;
                      }
                      if (!state.isValidMove(boardCell.row, boardCell.col)) {
                        setState(() {
                          _gameText = "Invalid move...";
                        });
                        return;
                      }
                      setState(() {
                        final content = _currentRound.isEven
                            ? GameState.playerOne
                            : GameState.playerTwo;
                        final moveResult = state.addMove(
                            boardCell.row, boardCell.col, content);

                        if (state.isWinningMove(
                            moveResult.row, moveResult.col, content)) {
                          _won = true;
                          _gameText = content == GameState.playerOne
                              ? "Player one has won in round $_currentRound"
                              : "Player two has won in round $_currentRound";
                        } else {
                          _gameText = content == GameState.playerOne
                              ? "Player one has made it's move"
                              : "Player two has made it's move...";

                          _currentRound++;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _mapStringToColor(boardCell.content),
                      ),
                    ),
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}

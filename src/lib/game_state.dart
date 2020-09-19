import 'dart:math';

class BoardCell {
  int row;
  int col;
  String content;
  BoardCell(this.row, this.col, this.content);
}

class GameState {
  static const int width = 7;
  static const int height = 6;
  static const String empty = "_";
  static const String playerOne = "x";
  static const String playerTwo = "o";

  List<List<String>> _board;
  static const String _playerOneWinPattern = "x, x, x, x";
  static const String _playerTwoWinPattern = "o, o, o, o";

  List<List<String>> _generateEmptyBoard() {
    return List.generate(height, (index) {
      return List.generate(width, (index) {
        return empty;
      });
    });
  }

  String _getRowStringForColumn(int col) {
    List<String> elements = [];
    for (var y = 0; y < height; y++) {
      elements.add(_board[y][col]);
    }
    return "[${elements.join(", ")}]";
  }

  String _getRowStringDiagonallyTopRight(int row, int col) {
    // This method checks the following pattern
    /*
      ["_", "_", "_", "x"]
      ["_", "_", "x", "_"]
      ["_", "x", "_", "_"]
      ["x", "_", "_", "_"]

    */
    final rowStartPos = max(row - 3, 0);
    final rowEndPos = min(rowStartPos + 3, height);
    final colStartPos = min(col + 3, width - 1);
    List<String> elements = [];
    for (var y = rowStartPos, x = colStartPos; y <= rowEndPos; y++, x--) {
      elements.add(_board[y][x]);
    }
    return "[${elements.join(", ")}]";
  }

  String _getRowStringDiagonallyTopLeft(int row, int col) {
// This method checks the following pattern
    /*
      ["x", "_", "_", "_"]
      ["_", "x", "_", "_"]
      ["_", "_", "x", "_"]
      ["_", "_", "_", "x"]

    */
    final rowStartPos = max(row - 3, 0);
    final rowEndPos = min(rowStartPos + 3, height);
    final colStartPos = max(col - 3, 0);
    List<String> elements = [];
    for (var y = rowStartPos, x = colStartPos; y <= rowEndPos; y++, x++) {
      elements.add(_board[y][x]);
    }
    return "[${elements.join(", ")}]";
  }

  GameState() {
    _board = _generateEmptyBoard();
  }

  List<BoardCell> getBoardContent() {
    List<BoardCell> boardContent = [];
    for (var row = 0; row < _board.length; row++) {
      for (var col = 0; col < _board[row].length; col++) {
        boardContent.add(BoardCell(row, col, _board[row][col]));
      }
    }
    return boardContent;
  }

  bool isValidMove(int row, int col) {
    return _board[row][col] == GameState.empty;
  }

  BoardCell addMove(int row, int col, String content) {
    // Go from bottom to top and search the first available empty space...
    for (var rowToPlace = height - 1; rowToPlace >= 0; rowToPlace--) {
      if (_board[rowToPlace][col] == GameState.empty) {
        _board[rowToPlace][col] = content;
        return BoardCell(rowToPlace, col, content);
      }
    }
    // This would be an invalid move, however we guard against that on the UI itself
    // Technically this should never be reached...
    return null;
  }

  bool _hasWonHorizontally(int row, int col, String content) {
    final rowString = _board[row].toString();
    final winPattern = content == GameState.playerOne
        ? _playerOneWinPattern
        : _playerTwoWinPattern;
    return rowString.contains(winPattern);
  }

  bool _hasWonVertically(int row, int col, String content) {
    final rowString = _getRowStringForColumn(col);
    final winPattern = content == GameState.playerOne
        ? _playerOneWinPattern
        : _playerTwoWinPattern;
    return rowString.contains(winPattern);
  }

  bool _hasWonDiagonally(int row, int col, String content) {
    final rowStringDiagonallyTopRight =
        _getRowStringDiagonallyTopRight(row, col);
    final rowStringDiagonallyTopLeft = _getRowStringDiagonallyTopLeft(row, col);
    final winPattern = content == GameState.playerOne
        ? _playerOneWinPattern
        : _playerTwoWinPattern;
    return rowStringDiagonallyTopRight.contains(winPattern) ||
        rowStringDiagonallyTopLeft.contains(winPattern);
  }

  bool isWinningMove(int row, int col, String content) {
    return _hasWonHorizontally(row, col, content) ||
        _hasWonVertically(row, col, content) ||
        _hasWonDiagonally(row, col, content);
  }

  bool isDraw() {
    // We have a draw when we do not have any row that is not empty anymore -> all places are filled out...
    return !_board.any((rowContent) =>
        rowContent.any((element) => element == GameState.empty));
  }

  reset() {
    _board = _generateEmptyBoard();
  }
}

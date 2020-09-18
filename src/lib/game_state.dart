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
    // TODO: Implement this...
    return false;
  }

  bool _hasWonDiagonally(int row, int col, String content) {
    // TODO: Implement this...
    return false;
  }

  isWinningMove(int row, int col, String content) {
    return _hasWonHorizontally(row, col, content) ||
        _hasWonVertically(row, col, content) ||
        _hasWonDiagonally(row, col, content);
  }

  reset() {
    _board = _generateEmptyBoard();
  }
}

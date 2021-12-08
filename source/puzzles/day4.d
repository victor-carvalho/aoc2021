module puzzles.day4;

import std.algorithm;
import std.array;
import std.conv: to;
import std.range;
import std.stdio;

alias Board = int[5][5];

struct Game {
    static Game parseInput(string filename) {
        auto game = Game();
        auto file = File(filename);
        auto firstLine = true;
        auto currentRow = 0;
        Board currentBoard;

        foreach (line; file.byLine) {
            if (line.empty) continue;

            if (firstLine) {
                game.draws = line.splitter(",").map!(to!int).array;
                firstLine = false;
                continue;
            }

            foreach (col, number; line.splitter.enumerate) {
                currentBoard[currentRow][col] = number.to!int;
            }
            currentRow++;

            if (currentRow == 5) {
                game.boards ~= currentBoard;
                currentRow = 0;
            }
        }

        return game;
    }

    int draw() {
        assert(currentDraw < draws.length);
        return draws[currentDraw++];
    }

    void updateBoards(int draw) {
        foreach (ref board; boards) {
            setNumberIfExists(board, draw);
        }
    }

    Board[] winnerBoards() {
        auto winnerBoardsCount = 0;
        for (int i = 0; i < boards.length - winnerBoardsCount; i++) {
            if (checkBoard(boards[i])) {
                winnerBoardsCount++;
                swap(boards[i], boards[$-winnerBoardsCount]);
            }
        }
        if (winnerBoardsCount == 0) return null;
        auto winnerBoards = boards[$-winnerBoardsCount..$];
        boards.length -= winnerBoardsCount;
        return winnerBoards;
    }

    bool allBoardsWon() {
        return boards.empty;
    }
private:
    void setNumberIfExists(ref Board board, int number) {
        foreach (i; 0..5) {
            foreach (j; 0..5) {
                if (board[i][j] == number) {
                    board[i][j] = -1;
                    return;
                }
            }
        }
    }

    bool checkBoard(ref Board board) {
        rowsCheck:
        foreach (i; 0..5) {
            foreach (j; 0..5) {
                if (board[i][j] >= 0)
                    continue rowsCheck;
            }
            return true;
        }

        colsCheck:
        foreach (i; 0..5) {
            foreach (j; 0..5) {
                if (board[j][i] >= 0)
                    continue colsCheck;
            }
            return true;
        }

        return false;
    }

    size_t currentDraw = 0;
    int[] draws;
    Board[] boards;
}

void firstPuzzle() {
    auto game = Game.parseInput("inputs/day4.txt");
    int draw;
    Board[] winnerBoards;
    do {
        draw = game.draw();
        game.updateBoards(draw);
        winnerBoards = game.winnerBoards;
    } while (winnerBoards == null);

    auto totalSum = winnerBoards.front[].map!((ref r) => r[].filter!(x => x >= 0).sum).sum;
    stdout.writefln("multiplying the total sum %d and current draw %d we get %d", totalSum, draw, totalSum * draw);
}

void secondPuzzle() {
    auto game = Game.parseInput("inputs/day4.txt");
    int draw;
    Board[] winnerBoards;
    do {
        draw = game.draw();
        game.updateBoards(draw);
        winnerBoards = game.winnerBoards;
    } while (!game.allBoardsWon);

    auto totalSum = winnerBoards.front[].map!((ref r) => r[].filter!(x => x >= 0).sum).sum;
    stdout.writefln("multiplying the total sum %d and current draw %d we get %d", totalSum, draw, totalSum * draw);
}
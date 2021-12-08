module puzzles.day3;

import std.array;
import std.algorithm;
import std.conv: to;
import std.stdio;

void firstPuzzle() {
  int[] oneCount;
  auto totalCount = 0;
  foreach (line; File("inputs/day3.txt", "r").byLine) {
    if (line.empty) continue;
    if (oneCount == null)
      oneCount = new int[line.length];
    for (int i = 0; i < line.length; i++) {
      if (line[i] == '1')
        oneCount[i] += 1;
    }
    totalCount += 1;
  }
  auto gammaRate = 0;
  for (int i = 0; i < oneCount.length; i++) {
    if (oneCount[i] >= (totalCount - oneCount[i])) {
      gammaRate |= 1 << (oneCount.length - i - 1);
    }
  }
  auto epsilonRate = gammaRate ^ ((1 << 12) - 1);
  stdout.writefln("multiplying the epsilon rate (%b) and the gamma rate (%b) we get %d", epsilonRate, gammaRate, gammaRate * epsilonRate);
}

int binaryStringToInt(string s) {
  auto result = 0;
  for (int i = 0; i < s.length; i++) {
    if (s[i] == '1')
      result |= 1 << (s.length - i - 1);
  }
  return result;
}

char findExpectedBit(alias pred, R)(R range, size_t col) {
  auto oneCount = 0;
  auto totalCount = 0;
  foreach(line; range) {
    if (line[col] == '1')
      oneCount += 1;
    totalCount += 1;
  }
  return pred(oneCount, totalCount - oneCount) ? '1' : '0';
}

int findRateForPattern(alias pred)(string[] allLines) {
  auto lines = allLines.dup;
  auto expectedBit = findExpectedBit!pred(lines, 0);
  for (int i = 0; i < 12; i++) {
    lines = lines.remove!(s => s[i] != expectedBit, SwapStrategy.unstable);
    if (lines.length == 1)
      break;
    expectedBit = lines.findExpectedBit!pred(i+1);
  }
  return lines.front.binaryStringToInt;
}

void secondPuzzle() {
  auto content = File("inputs/day3.txt", "r").byLineCopy.array;
  auto oxygenRate = findRateForPattern!((oneCount, zeroCount) => oneCount >= zeroCount)(content);
  auto co2Rate = findRateForPattern!((oneCount, zeroCount) => oneCount < zeroCount)(content);
  stdout.writefln("multiplying the oxygen generator rating (%012b) and the CO2 scrubber rating (%012b) we get %d", oxygenRate, co2Rate, oxygenRate * co2Rate);
}

// using a trie to store the lines
void secondPuzzleVariant() {
  auto node = new Node();
  foreach (line; File("inputs/day3.txt", "r").byLine) {
    node.add(line);
  }
  auto oxygenRate = node.mostCommon.binaryStringToInt;
  auto co2Rate = node.leastCommon.binaryStringToInt;
  stdout.writefln("multiplying the oxygen generator rating (%012b) and the CO2 scrubber rating (%012b) we get %d", oxygenRate, co2Rate, oxygenRate * co2Rate);
}

struct Node {
  void add(char[] s) {
    if (s.empty)
      return;
    if (s.front == '1') {
      if (ones == null)
        ones = new Node();
      ones.add(s[1..$]);
    } else {
      if (zeros == null)
        zeros = new Node();
      zeros.add(s[1..$]);
    }
    length += 1;
  }
private:
  size_t length;
  Node* ones;
  Node* zeros;
}

size_t nodeLength(Node* node) {
  return node == null ? 0 : node.length;
}

void chooseString(alias choose)(Node* node, Appender!string app) {
  Node* chosen;
  if (node.length == 1) {
    chosen = node.ones.nodeLength > 0 ? node.ones : node.zeros;
  } else {
    chosen = choose(node);
  }
  if (chosen == null)
    return;
  app ~= chosen == node.ones ? '1' : '0';
  chooseString!choose(chosen, app);
}

string mostCommon(Node* node) {
  auto app = appender!string;
  node.chooseString!((node) {
    return node.ones.nodeLength >= node.zeros.nodeLength ? node.ones : node.zeros;
  })(app);
  return app[];
}

string leastCommon(Node* node) {
  auto app = appender!string;
  node.chooseString!((node) {
    return node.ones.nodeLength < node.zeros.nodeLength ? node.ones : node.zeros;
  })(app);
  return app[];
}

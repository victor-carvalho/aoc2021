module puzzles.day3;

import std.array;
import std.algorithm;
import std.conv: to;
import std.stdio;
import utils.array;

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

int findRateForPattern(alias f)(string[] allLines) {
  auto lines = allLines.dup;
  auto oneCount = 0;
  auto totalCount = 0;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].front == '1')
      oneCount += 1;
    totalCount += 1;
  }
  auto expectedBit = f(oneCount, totalCount - oneCount);
  for (int i = 0; i < 12; i++) {
    auto current = 0;
    oneCount = 0;
    totalCount = 0;
    while (lines.length > 1 && current < lines.length) {
      if (lines[current][i] != expectedBit) {
        lines.fastRemove(current);
        continue;
      }
      if (i + 1 == lines[current].length)
        continue;
      if (lines[current][i+1] == '1')
        oneCount += 1;
      current += 1;
    }
    totalCount = current;
    expectedBit = f(oneCount, totalCount - oneCount);
  }
  return lines.front.binaryStringToInt;
}

void secondPuzzle() {
  auto content = File("inputs/day3.txt", "r").byLineCopy.array;
  auto oxygenRate = findRateForPattern!((oneCount, zeroCount) => oneCount >= zeroCount ? '1' : '0')(content);
  auto co2Rate = findRateForPattern!((oneCount, zeroCount) => oneCount < zeroCount ? '1' : '0')(content);
  stdout.writefln("multiplying the oxygen generator rating (%012b) and the CO2 scrubber rating (%012b) we get %d", oxygenRate, co2Rate, oxygenRate * co2Rate);
}
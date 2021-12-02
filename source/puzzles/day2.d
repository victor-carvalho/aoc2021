module puzzles.day2;

import std.algorithm;
import std.conv: to;
import std.range;
import std.stdio;

void firstPuzzle() {
  auto position = 0;
  auto depth = 0;
  foreach (line; File("inputs/day2.txt", "r").byLine) {
    if (line.empty) continue;
    auto spl = splitter(line);
    auto command = spl.front;
    spl.popFront;
    auto number = spl.front.to!int;
    switch (command) {
    case "forward":
      position += number;
      break;
    case "up":
      depth -= number;
      break;
    case "down":
      depth += number;
      break;
    default:
      assert(false, "shouldn't happen");
    }
  }
  stdout.writefln("multiplying the horizontal position %d and the depth %d we get %d", position, depth, position * depth);
}

void secondPuzzle() {
  auto position = 0;
  auto aim = 0;
  auto depth = 0;
  foreach (line; File("inputs/day2.txt", "r").byLine) {
    if (line.empty) continue;
    auto spl = splitter(line);
    auto command = spl.front;
    spl.popFront;
    auto number = spl.front.to!int;
    switch (command) {
    case "forward":
      position += number;
      depth += aim * number;
      break;
    case "up":
      aim -= number;
      break;
    case "down":
      aim += number;
      break;
    default:
      assert(false, "shouldn't happen");
    }
  }
  stdout.writefln("multiplying the horizontal position %d and the depth %d we get %d", position, depth, position * depth);
}
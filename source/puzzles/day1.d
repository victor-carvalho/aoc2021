module puzzles.day1;

import std.algorithm;
import std.conv: to;
import std.range;
import std.stdio;

void firstPuzzle() {
  auto measurements = File("inputs/day1.txt", "r").byLine.map!(to!int).array;
  stdout.writefln("there are %d measurements that are larger than the previous measurement", measurements.slide(2).count!(xs => xs[1] > xs[0]));
}

void secondPuzzle() {
  // TODO: there shouldn't be a need to collect the results in an array here
  auto measurements = File("inputs/day1.txt", "r").byLine.map!(to!int).array;
  auto slidingMeasurements = measurements.slide!(No.withPartial)(3).map!sum.array;
  stdout.writefln("there are %d sums that are larger than the sum", measurements.slide(2).count!(xs => xs[1] > xs[0]));
}

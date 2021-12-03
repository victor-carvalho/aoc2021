module utils.array;

import std.algorithm;
import std.array;

void fastRemove(ref string[] lines, size_t idx) {
  lines.swapAt(idx, lines.length - 1);
  lines = lines[0..lines.length - 1];
}
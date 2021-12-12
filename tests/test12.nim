import unittest
import day12

suite "day 12":
  test "part 1":
    check day12.solve("tests/test12a.txt").part1 == 10
    check day12.solve("tests/test12b.txt").part1 == 19
    check day12.solve("tests/test12c.txt").part1 == 226
  test "part 2":
    check day12.solve("tests/test12a.txt").part2 == 36
    check day12.solve("tests/test12b.txt").part2 == 103
    check day12.solve("tests/test12c.txt").part2 == 3509

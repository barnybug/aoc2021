import unittest
import day23

suite "day 23":
  test "part 1":
    let answer = day23.solve("tests/test23.txt")
    check answer.part1 == 12521
  test "part 2":
    let answer = day23.solve("tests/test23.txt")
    check answer.part2 == 47234

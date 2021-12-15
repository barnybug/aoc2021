import unittest
import day14

suite "day 14":
  test "part 1":
    let answer = day14.solve("tests/test14.txt")
    check answer.part1 == 1588
  test "part 2":
    let answer = day14.solve("tests/test14.txt")
    check answer.part2 == 0

import unittest
import day13

suite "day 13":
  test "part 1":
    let answer = day13.solve("tests/test13.txt")
    check answer.part1 == 17
  test "part 2":
    let answer = day13.solve("tests/test13.txt")
    check answer.part2 == 0

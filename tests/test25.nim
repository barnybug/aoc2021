import unittest
import day25

suite "day 25":
  test "part 1":
    let answer = day25.solve("tests/test25.txt")
    check answer.part1 == 58
  test "part 2":
    let answer = day25.solve("tests/test25.txt")
    check answer.part2 == 0

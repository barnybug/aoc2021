import unittest
import day19

suite "day 19":
  test "part 1":
    let answer = day19.solve("tests/test19.txt")
    check answer.part1 == 79
  test "part 2":
    let answer = day19.solve("tests/test19.txt")
    check answer.part2 == 3621

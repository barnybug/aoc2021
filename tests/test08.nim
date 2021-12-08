import unittest
import day08

suite "day 8":
  test "part 1":
    let answer = day08.solve("tests/test08.txt")
    check answer.part1 == 26
  test "part 2":
    let answer = day08.solve("tests/test08.txt")
    check answer.part2 == 61229

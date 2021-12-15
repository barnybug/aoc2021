import unittest
import day15

suite "day 15":
  test "part 1":
    let answer = day15.solve("tests/test15.txt")
    check answer.part1 == 40
  test "part 2":
    let answer = day15.solve("tests/test15.txt")
    check answer.part2 == 315

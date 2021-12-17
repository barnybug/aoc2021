import unittest
import day17

suite "day 17":
  test "part 1":
    let answer = day17.solve("tests/test17.txt")
    check answer.part1 == 45
  test "part 2":
    let answer = day17.solve("tests/test17.txt")
    check answer.part2 == 112

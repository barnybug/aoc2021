import unittest
import day05

suite "day 5":
  test "part 1":
    let answer = day05.solve("tests/test05.txt")
    check answer.part1 == 5
  test "part 2":
    let answer = day05.solve("tests/test05.txt")
    check answer.part2 == 12

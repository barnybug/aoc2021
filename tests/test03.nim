import unittest
import day03

suite "day 3":
  test "part 1":
    let answer = day03.solve("tests/test03.txt")
    check answer.part1 == 198

  test "part 2":
    let answer = day03.solve("tests/test03.txt")
    check answer.part2 == 230

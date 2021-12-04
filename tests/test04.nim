import unittest
import day04

suite "day 4":
  test "part 1":
    let answer = day04.solve("tests/test04.txt")
    check answer.part1 == 4512
  test "part 2":
    let answer = day04.solve("tests/test04.txt")
    check answer.part2 == 1924

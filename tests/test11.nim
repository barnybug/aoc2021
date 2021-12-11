import unittest
import day11

suite "day 11":
  test "part 1":
    let answer = day11.solve("tests/test11.txt")
    check answer.part1 == 1656
  test "part 2":
    let answer = day11.solve("tests/test11.txt")
    check answer.part2 == 195

import unittest
import day07

suite "day 7":
  test "part 1":
    let answer = day07.solve("tests/test07.txt")
    check answer.part1 == 37
  test "part 2":
    let answer = day07.solve("tests/test07.txt")
    check answer.part2 == 168

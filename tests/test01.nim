import unittest
import day01

suite "day 1":
  test "part 1":
    let answer = day01.solve("tests/test01.txt")
    check answer.part1 == 7
  test "part 2":
    let answer = day01.solve("tests/test01.txt")
    check answer.part2 == 5

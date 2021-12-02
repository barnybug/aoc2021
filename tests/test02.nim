import unittest
import day02

suite "day 2":
  test "part 1":
    let answer = day02.solve("tests/test02.txt")
    check answer.part1 == 150
  test "part 2":
    let answer = day02.solve("tests/test02.txt")
    check answer.part2 == 900


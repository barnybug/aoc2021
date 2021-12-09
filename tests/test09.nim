import unittest
import day09

suite "day 9":
  test "part 1":
    let answer = day09.solve("tests/test09.txt")
    check answer.part1 == 15
  test "part 2":
    let answer = day09.solve("tests/test09.txt")
    check answer.part2 == 1134

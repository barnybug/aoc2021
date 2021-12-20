import unittest
import day20

suite "day 20":
  test "part 1":
    let answer = day20.solve("tests/test20.txt")
    check answer.part1 == 35
  test "part 2":
    let answer = day20.solve("tests/test20.txt")
    check answer.part2 == 3351

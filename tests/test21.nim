import unittest
import day21

suite "day 21":
  test "part 1":
    let answer = day21.solve("tests/test21.txt")
    check answer.part1 == 739785
  test "part 2":
    let answer = day21.solve("tests/test21.txt")
    check answer.part2 == 444356092776315

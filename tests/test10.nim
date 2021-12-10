import unittest
import day10

suite "day 10":
  test "part 1":
    let answer = day10.solve("tests/test10.txt")
    check answer.part1 == 26397
  test "part 2":
    let answer = day10.solve("tests/test10.txt")
    check answer.part2 == 288957

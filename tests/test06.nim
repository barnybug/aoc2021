import unittest
import day06

suite "day 6":
  test "part 1":
    let answer = day06.solve("tests/test06.txt")
    check answer.part1 == 5934
  test "part 2":
    let answer = day06.solve("tests/test06.txt")
    check answer.part2 == 26984457539
    

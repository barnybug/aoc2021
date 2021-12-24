import unittest
import day24

suite "day 24":
  test "part 1":
    for (input, expected) in [
      ([9,9,9,9,9,9,9,9,9,9,9,9,9,9], 3310156106),
      ([9,8,9,9,9,9,9,9,9,9,9,9,9,9], 3310156106),
      ([9,9,9,9,9,9,9,9,9,9,9,9,9,1], 838829898'i64),
      ([5,4,3,2,1,9,8,7,6,5,4,3,2,1], 753303726'i64),
      ([6,4,3,2,1,9,8,7,6,5,4,3,2,1], 28973220'i64),
      ([1,2,3,4,5,6,7,8,9,1,2,3,4,5], 2975936'i64),
    ]:
      let result = day24.run(input)
      check result == expected
  # test "part 2":
  #   let answer = day24.solve("tests/test24.txt")
  #   check answer.part2 == 0

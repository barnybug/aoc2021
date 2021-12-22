import unittest
import day22

suite "day 22":
  test "part 1":
    let answer = day22.part1("tests/test22.txt")
    check answer == 590784

  test "overlap":
    let c1 = (1, 2, 3, 4, 5, 6)
    let c2 = (2, 3, 4, 5, 6, 7)
    let c3 = (3, 4, 3, 4, 5, 6)
    check c1.intersect(c1)
    check c1.intersect(c2)
    check c2.intersect(c1)
    check not c1.intersect(c3)
    check not c3.intersect(c1)
    check c2.intersect(c3)
    check c3.intersect(c2)

  test "contains":
    let c1 = (1, 2, 3, 4, 5, 6)
    let c2 = (1, 1, 3, 3, 5, 6)
    check c1.contains(c1)
    check c1.contains(c2)
    check not c2.contains(c1)

  test "len":
    let c1 = (1, 2, 3, 4, 5, 6)
    check c1.len == 8

  test "slices":
    check slices(1, 2, 3, 4) == @[(1,2)]
    check slices(1, 4, 2, 3) == @[(1,1), (2,3), (4,4)]
    check slices(1, 4, 1, 3) == @[(1,3), (4,4)]
    check slices(1, 4, 2, 5) == @[(1,1), (2,4), (5,5)]
    
  test "-":
    let c1 = (1, 3, 4, 6, 7, 9)
    let c2 = (2, 2, 5, 5, 8, 8)
    let c3 = (4, 6, 4, 6, 7, 9)
    check (c1 - c3) == @[c1]
    check (c3 - c1) == @[c3]
    check (c1 - c2).len == 26

  test "part 2":
    let answer = day22.part2("tests/test22b.txt")
    check answer == 2758514936282235

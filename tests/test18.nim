import unittest
import day18

suite "day 18":
  test "parse":
    let parsed = day18.parse("[9,[8,7]]")
    check parsed == @[OPEN, 9, OPEN, 8, 7, CLOSE, CLOSE]
    check $(parsed) == "[9,[8,7]]"

  test "string":
    var s1 = "[[[[[9,8],1],2],3],4]".parse
    check $(s1) == "[[[[[9,8],1],2],3],4]"

  test "explode":
    var s1 = "[[[[[9,8],1],2],3],4]".parse
    check s1.explode
    check $(s1) == "[[[[0,9],2],3],4]"

    var s2 = "[7,[6,[5,[4,[3,2]]]]]".parse
    check s2.explode
    check $(s2) == "[7,[6,[5,[7,0]]]]"

    var s3 = "[[6,[5,[4,[3,2]]]],1]".parse
    check s3.explode
    check $(s3) == "[[6,[5,[7,0]]],3]"

    var s4 = "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]".parse
    check s4.explode
    check $(s4) == "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]"

    var s5 = "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]".parse
    check s5.explode
    check $(s5) == "[[3,[2,[8,0]]],[9,[5,[7,0]]]]"

  test "split":
    var s1 = "[[[[0,7],4],[0,[0,5]]],[1,1]]".parse
    s1[10] = 15
    check s1.split
    check $(s1) == "[[[[0,7],4],[[7,8],[0,5]]],[1,1]]"

  test "addreduce":
    var s1 = "[[[[4,3],4],4],[7,[[8,4],9]]]".parse
    let s2 = "[1,1]".parse
    s1 += s2
    s1.reduce
    check $(s1) == "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]"

  test "addlist":
    check $(addlist(["[1,1]", "[2,2]", "[3,3]", "[4,4]"])) == "[[[[1,1],[2,2]],[3,3]],[4,4]]"
    check $(addlist(["[1,1]", "[2,2]", "[3,3]", "[4,4]", "[5,5]"])) == "[[[[3,0],[5,3]],[4,4]],[5,5]]"
    check $(addlist(["[1,1]", "[2,2]", "[3,3]", "[4,4]", "[5,5]", "[6,6]"])) == "[[[[5,0],[7,4]],[5,5]],[6,6]]"

    check $(addlist([
      "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
      "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]",
      "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]",
      "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]",
      "[7,[5,[[3,8],[1,4]]]]",
      "[[2,[2,2]],[8,[8,1]]]",
      "[2,9]",
      "[1,[[[9,3],9],[[9,0],[0,7]]]]",
      "[[[5,[7,4]],7],1]",
      "[[[[4,2],2],6],[8,7]]",
    ])) == "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"

  test "magnitude":
    check "[9,1]".parse.magnitude == 29
    check "[1,9]".parse.magnitude == 21
    check "[[9,1],[1,9]]".parse.magnitude == 129
    check "[[1,2],[[3,4],5]]".parse.magnitude == 143
    check "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]".parse.magnitude == 1384
    check "[[[[1,1],[2,2]],[3,3]],[4,4]]".parse.magnitude == 445
    check "[[[[3,0],[5,3]],[4,4]],[5,5]]".parse.magnitude == 791
    check "[[[[5,0],[7,4]],[5,5]],[6,6]]".parse.magnitude == 1137
    check "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]".parse.magnitude == 3488

  test "part 1":
    let answer = day18.solve("tests/test18.txt")
    check answer.part1 == 4140
  test "part 2":
    let answer = day18.solve("tests/test18.txt")
    check answer.part2 == 3993

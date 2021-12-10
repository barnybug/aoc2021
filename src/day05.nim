import common, math, sequtils, strscans

proc solve*(input: string): Answer =
    var grid1 = newSeq[uint8](1000*1000)
    var grid2 = newSeq[uint8](1000*1000)
    for line in lines input:
        var x1, x2, y1, y2: int
        assert line.scanf("$i,$i -> $i,$i", x1, y1, x2, y2)
        var p = x1 + y1*1000
        let dp = sgn(x2-x1) + sgn(y2-y1)*1000
        let steps = max(abs(y1-y2), abs(x1-x2))
        for i in 0..steps:
            if x1 == x2 or y1 == y2:
                inc grid1[p]
            inc grid2[p]
            p += dp

    result.part1 = countIt(grid1, it > 1)
    result.part2 = countIt(grid2, it > 1)

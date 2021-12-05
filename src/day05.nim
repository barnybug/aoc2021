import common, sequtils, strscans, tables

type Point = tuple[x, y: int]

proc count(a, b: int): seq[int] =
    if a < b: toSeq(countup(a, b)) else: toSeq(countdown(a, b))

proc partn(input: string, part: int): int =
    var grid: CountTable[Point]
    for line in lines input:
        var x1, x2, y1, y2: int
        assert line.scanf("$i,$i -> $i,$i", x1, y1, x2, y2)
        if x1 != x2 and y1 != y2 and part == 1:
            continue
        let xs = if x1 == x2: repeat(x1, abs(y1-y2)+1) else: count(x1, x2)
        let ys = if y1 == y2: repeat(y1, abs(x1-x2)+1) else: count(y1, y2)
        for (x, y) in zip(xs, ys):
            grid.inc (x, y)

    for count in grid.values:
        if count > 1:
            inc result

proc solve*(input: string): Answer =
    result.part1 = partn(input, 1)
    result.part2 = partn(input, 2)

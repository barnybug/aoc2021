import algorithm, common, deques, math, sequtils, tables

type Point = (int, int)
type Grid = Table[Point, int]

iterator neighbours(p: Point): Point =
    let (x, y) = p
    yield (x-1, y)
    yield (x+1, y)
    yield (x, y-1)
    yield (x, y+1)

proc size(grid: Grid, p: Point): int =
    var q = initDeque[Point]()
    var visited: CountTable[Point]
    q.addFirst(p)
    while q.len > 0:
        let current = q.popFirst()
        if current in visited:
            continue
        inc result
        visited.inc(current)
        for n in current.neighbours:
            if grid.getOrDefault(n, 9) < 9:
                q.addLast(n)

proc solve*(input: string): Answer =
    var grid: Grid
    var y: int
    for line in lines input:
        for x, c in line:
            grid[(x,y)] = ord(c) - ord('0')
        inc y
    
    var basins: seq[int]
    for p, c in grid.pairs:
        if toSeq(p.neighbours).allIt(c < grid.getOrDefault(it, 9)):
            result.part1 += c + 1
            basins.add size(grid, p)
    
    basins.sort()
    result.part2 = prod(basins[^3..^1])

import common, sequtils, strutils

type Grid[N: static[int], T] = array[N, array[N, T]]
type Point = (int, int)
type Grid10 = Grid[10, uint8]

iterator xys(grid: Grid): Point =
    for x in 0..grid[0].high:
        for y in 0..grid.high:
            yield (x, y)

iterator neighbours(grid: Grid, point: Point): Point =
    let (x, y) = point
    for (dx, dy) in [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]:
        if x+dx < 0 or x+dx > grid[0].high or y+dy < 0 or y+dy > grid.high: continue
        yield (x+dx, y+dy)

proc parse(grid: var Grid, input: string) =
    for y, line in toSeq(lines input):
        for x, c in line:
            grid[(x, y)] = uint8(ord(c) - ord('0'))

proc `[]`(grid: Grid, point: Point): Grid.T =
    return grid[point[1]][point[0]]

proc `[]`(grid: var Grid, point: Point): var Grid.T =
    result = grid[point[1]][point[0]]

proc `[]=`(grid: var Grid, point: Point, val: Grid.T) =
    grid[point[1]][point[0]] = val

proc `$`(grid: Grid): string =
    for line in grid:
        result = result & line.join("") & "\n"

proc solve*(input: string): Answer =
    var grid: Grid10
    grid.parse(input)

    for step in 1..1000:
        var flashed: seq[Point]
        for xy in grid.xys:
            inc grid[xy]
            if grid[xy] == 10:
                flashed.add xy

        # propagate flashes
        while flashed.len > 0:
            let p = flashed.pop
            for np in grid.neighbours(p):
                inc grid[np]
                if grid[np] == 10:
                    flashed.add np

        # reset flashers
        var flashCount = 0
        for xy in grid.xys:
            if grid[xy] > 9:
                grid[xy] = uint8(0)
                inc flashCount
        
        if step <= 100:
            result.part1 += flashCount
        if flashCount == 100:
            result.part2 = step
            break

        # echo &"Step: {step}"
        # echo grid

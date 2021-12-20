import common, sequtils

const size = 100 * 2
const offset = 50

type Grid[N: static[int]] = array[N, array[N, bool]]

proc sum(grid: Grid): int =
    for row in grid:
        for x in row:
            if x: inc result

proc solve*(input: string): Answer =
    let lines = toSeq(input.lines)
    let lookup = lines[0]
    var grid: Grid[size]
    for y, line in lines[2..^1]:
        for x, c in line:
            if c == '#':
                grid[y+offset][x+offset] = true

    var next: Grid[size]
    for i in 1..50:
        for y in 0..<size:
            for x in 0..<size:
                var l = 0
                for (dx, dy) in [(-1, -1), (0, -1), (1, -1), (-1, 0), (0, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]:
                    let nx = min(max(x+dx, 0), size-1)
                    let ny = min(max(y+dy, 0), size-1)
                    l = l shl 1 + int(grid[ny][nx])

                next[y][x] = (lookup[l] == '#')
        grid = next
        if i == 2:
            result.part1 = grid.sum
        elif i == 50:
            result.part2 = grid.sum

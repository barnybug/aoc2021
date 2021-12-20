import common, sequtils, sets

type Point = (int, int)

proc solve*(input: string): Answer =
    let lines = toSeq(input.lines)
    let lookup = lines[0]
    var grid: HashSet[Point]
    for y, line in lines[2..^1]:
        for x, c in line:
            if c == '#':
                grid.incl (x, y)

    var minx = 0
    var maxx = grid.mapIt(it[0]).max
    var miny = 0
    var maxy = grid.mapIt(it[1]).max

    var default = 0
    for i in 1..50:
        var next: HashSet[Point]
        for y in (miny-1)..(maxy+1):
            for x in (minx-1)..(maxx+1):
                var l = 0
                for (dx, dy) in [(-1, -1), (0, -1), (1, -1), (-1, 0), (0, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]:
                    let v = if x+dx < minx or x+dx > maxx or y+dy < miny or y+dy > maxy: default
                    elif (x+dx, y+dy) in grid: 1
                    else: 0
                    l = l shl 1 + v

                if lookup[l] == '#':
                    next.incl (x,y)
        grid = next
        dec minx
        dec miny
        inc maxx
        inc maxy

        if lookup[0] == '#':
            default = 1-default
        if i == 2:
            result.part1 = grid.len
        elif i == 50:
            result.part2 = grid.len

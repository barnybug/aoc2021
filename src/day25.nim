import common, sequtils

proc solve*(input: string): Answer =
    var grid: array[140, array[140, uint8]]
    var height, width: int
    let lines = toSeq(input.lines)
    for y, line in lines:
        width = line.len
        for x, c in line:
            if c == '>':
                grid[y][x] = 1
            elif c == 'v':
                grid[y][x] = 2
    height = lines.len
    
    var step = 0
    while true:
        var next: array[140, array[140, uint8]]
        var moved = false
        # east
        for y in 0..<height:
            for x in 0..<width:
                let nx = (x+1) mod width
                if grid[y][x] == 1 and grid[y][nx] == 0:
                        next[y][nx] = 1
                        moved = true
                elif grid[y][x] != 0:
                    next[y][x] = grid[y][x]
        # south
        grid = next
        var next2: array[140, array[140, uint8]]
        for y in 0..<height:
            for x in 0..<width:
                let ny = (y+1) mod height
                if grid[y][x] == 2 and grid[ny][x] == 0:
                    next2[ny][x] = 2
                    moved = true
                elif grid[y][x] != 0:
                    next2[y][x] = grid[y][x]
        grid = next2
        inc step
        if not moved:
            break

    # echo grid
    result.part1 = step
    result.part2 = 0

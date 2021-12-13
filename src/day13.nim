import common, sequtils, strscans, strutils, sets

proc solve*(input: string): Answer =
    var grid: HashSet[(int, int)]
    let parts = input.readFile.split("\n\n")
    for line in parts[0].splitLines:
        let ps = line.split(",").mapIt(parseInt(it))
        incl grid, (ps[0], ps[1])

    for i, line in toSeq(parts[1].splitLines):
        if line == "": continue
        var newGrid: HashSet[(int, int)]
        var fold: int
        if line.scanf("fold along x=$i", fold):
            for pos in grid:
                let (x, y) = pos
                let nx = if x < fold: x else: 2*fold-x
                incl newGrid, (nx, y)
        elif line.scanf("fold along y=$i", fold):
            for pos in grid:
                let (x, y) = pos
                let ny = if y < fold: y else: 2*fold-y
                incl newGrid, (x, ny)

        if i == 0:
            result.part1 = newGrid.len
        grid = newGrid

    let mx = grid.mapIt(it[0]).max
    let my = grid.mapIt(it[1]).max
    var output = (0..my).mapIt(' '.repeat(mx+1))
    for (x, y) in grid:
        output[y][x] = '#'
    echo output.join("\n")

import common, algorithm, sequtils, strscans

type Cube* = tuple[x1, x2, y1, y2, z1, z2: int]
type CubeB* = tuple[cube: Cube, on: bool]

proc overlap(a1, a2, b1, b2: int): bool = a2 >= b1 and a1 <= b2

proc intersect*(a, b: Cube): bool =
    overlap(a.x1, a.x2, b.x1, b.x2) and overlap(a.y1, a.y2, b.y1, b.y2) and overlap(a.z1, a.z2, b.z1, b.z2)

proc contains*(a, b: Cube): bool =
    a.x1 <= b.x1 and a.x2 >= b.x2 and a.y1 <= b.y1 and a.y2 >= b.y2 and a.z1 <= b.z1 and a.z2 >= b.z2

proc len*(a: Cube): int =
    (a.x2 - a.x1 + 1) * (a.y2 - a.y1 + 1) * (a.z2 - a.z1 + 1)

proc slices*(a1, a2, b1, b2: int): seq[(int, int)] =
    if a2 < b1 or a1 > b2:
        return @[(a1, a2)] # no overlap
    var ls = @[a1, a2+1, b1, b2+1]
    ls.sort
    for i in 0..<ls.high:
        if ls[i] < ls[i+1]:
            result.add (ls[i], ls[i+1]-1)

proc `-`*(a, b: Cube): seq[Cube] =
    if not a.intersect(b):
        return @[a]

    # slice a on b boundaries on each axis
    let xs = slices(a.x1, a.x2, b.x1, b.x2)
    let ys = slices(a.y1, a.y2, b.y1, b.y2)
    let zs = slices(a.z1, a.z2, b.z1, b.z2)
    # then evaluate sub-cubes for containership
    for (x1, x2) in xs:
        for (y1, y2) in ys:
            for (z1, z2) in zs:
                let sub = (x1, x2, y1, y2, z1, z2)
                if a.contains(sub) and not b.contains(sub):
                    result.add(sub)

proc valid(a, b: int): bool =
    return a >= -50 and a <= 50 and b >= -50 and b <= 50

proc parse(line: string): (Cube, bool) =
    var action: string
    var c: Cube
    assert line.scanf("$+ x=$i..$i,y=$i..$i,z=$i..$i", action, c.x1, c.x2, c.y1, c.y2, c.z1, c.z2)
    return (c, action == "on")

proc small(cube: Cube): bool = valid(cube.x1, cube.x2) and valid(cube.y1, cube.y2) and valid(cube.z1, cube.z2)

proc solveSmall(cubes: seq[CubeB]): int =
    var grid: array[-50..50, array[-50..50, array[-50..50, bool]]]
    for (cube, on) in cubes:
        for x in cube.x1..cube.x2:
            for y in cube.y1..cube.y2:
                for z in cube.z1..cube.z2:
                    if grid[x][y][z] != on:
                        grid[x][y][z] = on
                        if on:
                            inc result
                        else:
                            dec result

proc solveBig(cubes: seq[CubeB]): int =
    var grid: seq[Cube]
    for (cube, on) in cubes:
        var next: seq[Cube]
        for c in grid:
            next.add c - cube
        grid = next
        if on:
            grid.add cube
    for cube in grid:
        result += cube.len

proc solve*(input: string): Answer =
    var cubes: seq[CubeB]
    for line in input.lines:
        cubes.add line.parse

    let smallCubes = cubes.filterIt(it.cube.small)
    result.part1 = solveBig(smallCubes)

    let largeCubes = cubes.filterIt(not it.cube.small)
    result.part2 = result.part1 + solveBig(largeCubes)

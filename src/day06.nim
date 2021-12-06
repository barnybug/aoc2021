import common, math

proc solve*(input: string): Answer =
    var numbers = parseIntList(readFile input)
    var f: array[9, int]
    for n in numbers: inc f[n]

    for day in 1..256:
        let g = [f[1], f[2], f[3], f[4], f[5], f[6], f[7]+f[0], f[8], f[0]]
        f = g
        if day == 80:
            result.part1 = f.sum
    result.part2 = f.sum

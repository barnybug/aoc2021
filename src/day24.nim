import common, math

proc run*(i: array[14, int]): int =
    var x, z: int
    z = (i[13] + 1) * 26 + (i[12] + 9)

    if i[11] - 2 != i[10]:
        z *= 26
        z += i[10] + 6

    z *= 26
    z += i[9] + 6

    if i[8] - 1 != i[7]:
        z *= 26
        z += i[7] + 13

    if i[6] - 3 != i[5]:
        z *= 26
        z += i[5] + 7

    if i[4] - 7 != i[3]:
        z *= 26
        z += i[3] + 10

    x = z mod 26
    if x - 11 != i[2]:
        z -= x
        z += i[2] + 14
    else:
        z = z div 26

    x = z mod 26
    if x - 6 != i[1]:
        z -= x
        z += i[1] + 7
    else:
        z = z div 26

    x = z mod 26
    if x - 5 != i[0]:
        z -= x
        z += i[0] + 1
    else:
        z = z div 26
    return z

proc fill_missing(inp: var array[14, int]) =
    inp[10] = inp[11] - 2
    inp[7] = inp[8] - 1
    inp[5] = inp[6] - 3
    inp[3] = inp[4] - 7
    inp[2] = inp[9] - 5
    inp[1] = inp[12] + 3
    inp[0] = inp[13] - 4

proc solve*(input: string): Answer =
    var p1: array[14, int]
    p1[13] = 9
    p1[12] = 6
    p1[11] = 9
    p1[9] = 9
    p1[8] = 9
    p1[6] = 9
    p1[4] = 9
    fill_missing(p1)
    assert run(p1) == 0
    for i, j in p1:
        result.part1 += int(j)*10^i

    var p2: array[14, int]
    p2[13] = 5
    p2[12] = 1
    p2[11] = 3
    p2[9] = 6
    p2[8] = 2
    p2[6] = 4
    p2[4] = 8
    fill_missing(p2)
    assert run(p2) == 0

    for i, j in p2:
        result.part2 += int(j)*10^i

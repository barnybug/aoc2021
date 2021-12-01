import common

proc increases(ns: seq[int], stride: int): int =
    for i in 0..<ns.len-stride:
        if ns[i+stride] > ns[i]:
            inc result

proc solve*(input: string): Answer =
    let numbers = parseIntList(readFile input)
    result.part1 = increases(numbers, 1)
    # Each sum of threes has the 1st and 2nd in common with the next threes, so only necessary to compare 0th and 3rd
    result.part2 = increases(numbers, 3)

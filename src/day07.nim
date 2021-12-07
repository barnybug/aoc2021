import common, math, sequtils

proc best(numbers: seq[int], costfn: proc(a, b: int): int): int =
    var costs: seq[int]
    for i in min(numbers)..max(numbers):
        let cost = numbers.mapIt(costfn(it, i)).sum
        costs.add(cost)
    return min(costs)

proc difference(a, b: int): int = abs(a-b)

proc triangular(a, b: int): int =
    let i = abs(a-b)
    return i*(i+1) div 2

proc solve*(input: string): Answer =
    let numbers = parseIntList(readFile input)
    result.part1 = best(numbers, difference)
    result.part2 = best(numbers, triangular)

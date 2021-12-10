import algorithm, common, math, sequtils

proc best(numbers: seq[int]): int =
    var costs: seq[int]
    for i in numbers[0]..numbers[^1]:
        var cost = 0
        for b in numbers:
            let x = abs(b-i)
            cost += x*(x+1) div 2
        costs.add(cost)
    return min(costs)

proc solve*(input: string): Answer =
    var numbers = parseIntList(readFile input)
    numbers.sort
    let median = numbers[numbers.len div 2]
    result.part1 = numbers.mapIt(abs(it-median)).sum
    result.part2 = best(numbers)

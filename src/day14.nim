import common, strutils, tables

proc solve*(input: string): Answer =
    let parts = input.readFile.split("\n\n")
    var current = parts[0]
    var rules: Table[string, char]
    for line in parts[1].splitLines:
        if line == "": continue
        rules[line[0..1]] = line[6]

    var bag: CountTable[string]
    for i in 0..current.len-2:
        bag.inc current[i..i+1]

    for i in 1..40:
        var nextBag: CountTable[string]
        for pair, count in bag:
            let c = rules[pair]
            nextBag.inc(pair[0] & c, count)
            nextBag.inc(c & pair[1], count)
        bag = nextBag

        var counts: CountTable[char]
        for pair, count in bag:
            counts.inc(pair[0], count)
            counts.inc(pair[1], count)
        # add start and end
        counts.inc(current[0])
        counts.inc(current[^1])
        # everything is double counted now, so half
        for c, count in counts:
            counts[c] = count div 2

        if i == 10:
            result.part1 = counts.largest[1] - counts.smallest[1]
        if i == 40:
            result.part2 = counts.largest[1] - counts.smallest[1]

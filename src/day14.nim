import common, strutils, tables

proc solve*(input: string): Answer =
    let parts = input.readFile.split("\n\n")
    var current = parts[0]
    var rules: Table[string, char]
    for line in parts[1].splitLines:
        if line == "": continue
        rules[line[0..1]] = line[6]

    for i in 1..40:
        var next: string
        for j in 0..current.len-2:
            next &= current[j]
            next &= rules[current[j..j+1]]
        next &= current[^1]
        current = next

        # echo i, " ", current
        var counts: CountTable[char]
        for c in current:
            counts.inc(c)
        echo i, " ", current.len, " ", counts

        if i == 10:
            result.part1 = counts.largest[1] - counts.smallest[1]
    
    result.part2 = 0

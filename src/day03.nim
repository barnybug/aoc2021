import common, sequtils

proc fromBin(s: string): int = 
    for col in 0..s.high:
        result = (result shl 1) + int(s[col] == '1')

proc countColumn(lines: seq[string], col: int): int = countIt(lines, it[col] == '1')

proc filterDown(lines: seq[string], col: int, pick: string): string =
    let common = (if countColumn(lines, col) >= (lines.len+1) div 2: pick[0] else: pick[1])
    let selected = lines.filterIt(it[col] == common)
    return if selected.len > 1: filterDown(selected, col+1, pick) else: selected[0]

proc solve*(input: string): Answer =
    let lines = toSeq(lines input)
    let width = lines[0].len
    var gamma = 0
    for col in 0..<width:
        gamma = gamma shl 1
        if countColumn(lines, col) > lines.len div 2:
            inc gamma
    let epsilon = gamma xor ((1 shl width)-1)
    result.part1 = gamma * epsilon

    let oxygen = filterDown(lines, 0, "10").fromBin
    let co2 = filterDown(lines, 0, "01").fromBin
    result.part2 = oxygen * co2

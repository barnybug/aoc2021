import common, sequtils

proc fromBin(s: string): int =
    for c in s:
        result = result*2 + (if c == '1': 1 else: 0)

proc countColumn(lines: seq[string], col: int): int =
    for line in lines:
        if line[col] == '1':
            inc result

proc filterDown(lines: seq[string], col: int, pick: string): string =
    var common = (if countColumn(lines, col) >= (lines.len+1) div 2: pick[0] else: pick[1])
    var selected: seq[string]
    for p in lines:
        if p[col] == common: selected.add(p)
    if selected.len == 1:
        return selected[0]
    return filterDown(selected, col+1, pick)


proc solve*(input: string): Answer =
    let lines = toSeq(lines input)
    let width = lines[0].len
    var gamma: int
    for col in 0..<width:
        gamma = (gamma shl 1)
        if countColumn(lines, col) > lines.len div 2:
            inc gamma
    let epsilon = gamma xor ((1 shl width)-1)
    result.part1 = gamma * epsilon

    let oxygen = filterDown(lines, 0, "10").fromBin
    let co2 = filterDown(lines, 0, "01").fromBin
    result.part2 = oxygen * co2

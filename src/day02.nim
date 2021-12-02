import common, strscans

proc solve*(input: string): Answer =
    var action: string
    var depth, depth2, pos, n: int
    for line in lines input:
        assert scanf(line, "$+ $i", action, n)
        case action
        of "forward": pos += n; depth2 += depth * n
        of "down": depth += n
        of "up": depth -= n
    result.part1 = pos*depth
    result.part2 = pos*depth2

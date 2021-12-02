import common, strscans

type Command = tuple[action: string, n: int]

proc parse(input: string): seq[Command] =
    var command: Command
    for line in lines input:
        assert scanf(line, "$+ $i", command.action, command.n)
        result.add command

proc part1(commands: seq[Command]): int =
    var depth, pos: int
    for c in commands:
        case c.action
        of "forward": pos += c.n
        of "down": depth += c.n
        of "up": depth -= c.n
    return depth * pos

proc part2(commands: seq[Command]): int =
    var depth, pos, aim: int
    for c in commands:
        case c.action
        of "forward": pos += c.n; depth += aim * c.n
        of "down": aim += c.n
        of "up": aim -= c.n
    return depth * pos

proc solve*(input: string): Answer =
    let commands = parse(input)
    result.part1 = part1(commands)
    result.part2 = part2(commands)

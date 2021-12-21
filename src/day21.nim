import common, strutils, tables

proc parse(input: string): (int, int) =
    var pos: seq[int]
    for line in input.lines:
        pos.add line.split(": ")[1].parseInt
    return (pos[0], pos[1])

proc part1(p1, p2: int): int =
    var (p1, p2) = (p1, p2)
    var s1, s2: int
    var dice = 1
    while true:
        let roll1 = dice*3 + 3
        p1 = (p1 + roll1 - 1) mod 10 + 1
        s1 += p1
        dice += 3
        if s1 >= 1000:
            break

        let roll2 = dice*3 + 3
        p2 = (p2 + roll2 - 1) mod 10 + 1
        s2 += p2
        dice += 3
        if s2 >= 1000:
            break
    if s1 >= 1000:
        return s2*(dice-1)
    return s1*(dice-1)

type State = tuple[p1, p2, s1, s2: int]

const rolls = [(3, 1), (4, 3), (5, 6), (6, 7), (7, 6), (8, 3), (9, 1)]
var memo: Table[State, (int, int)]

proc part2(state: State): (int, int) =
    if state in memo:
        return memo[state]
    for (roll, t) in rolls:
        let np1 = (state.p1 + roll - 1) mod 10 + 1
        let ns1 = state.s1+np1
        if ns1 >= 21:
            result[0] += t
            continue
        let (w2, w1) = part2((p1: state.p2, p2: np1, s1: state.s2, s2: ns1))
        result[0] += t * w1
        result[1] += t * w2

    memo[state] = result

proc solve*(input: string): Answer =
    var (p1, p2) = parse(input)
    result.part1 = part1(p1, p2)
    let (w1, w2) = part2((p1: p1, p2: p2, s1: 0, s2: 0))
    result.part2 = max(w1, w2)

import common, sequtils

const OPEN* = -1'i8
const CLOSE* = -2'i8

type SNum = seq[int8]

proc parse*(s: string): SNum =
    for c in s:
        case c
        of '[':
            result.add OPEN
        of ']':
            result.add CLOSE
        of ',':
            discard
        else:
            result.add int8(ord(c)-ord('0'))

proc `$`*(n: SNum): string =
    var previous: int8 = OPEN
    for i in n:
        case i
        of OPEN:
            if previous != OPEN:
                result.add ','
            result.add '['
        of CLOSE:
            result.add ']'
        else:
            if previous != OPEN:
                result.add ','
            result.add $(i)
        previous = i


proc explode*(n: var SNum): bool =
    var deep = 0
    for i, v in n:
        if v == OPEN:
            inc deep
        elif v == CLOSE:
            if deep < 5:
                dec deep
                continue
            # explode!
            let p1 = n[i-2]
            for j in countdown(i-3, 0):
                if n[j] >= 0:
                    n[j] += p1
                    break
            let p2 = n[i-1]
            for j in i..n.high:
                if n[j] >= 0:
                    n[j] += p2
                    break
            # reduce this pair to 0
            # [ A B ] -> 0
            n[i-3] = 0
            delete(n, i-2, i)
            return true

proc split*(n: var SNum): bool = 
    for i, v in n:
        if v < 10: continue
        n[i] = OPEN
        n.insert(@[v div 2, (v+1) div 2, CLOSE], i+1)
        return true

proc reduce*(n: var SNum) =
    while true:
        if not n.explode:
            if not n.split:
                break

proc `+=`*(a: var SNum, b: SNum) =
    a.insert(@[OPEN], 0)
    a.add(b)
    a.add(CLOSE)

proc addlist*(list: openarray[string]): SNum =
    var a = list[0].parse
    for s in list[1..^1]:
        let b = s.parse
        a += b
        a.reduce
    return a

proc recmag(n: SNum, i: var int): int =
    case n[i]
    of OPEN:
        inc i
        result = 3 * recmag(n, i)
        result += 2 * recmag(n, i)
    of CLOSE:
        assert false
    else:
        result = n[i]
    inc i

proc magnitude*(n: SNum): int =
    var i = 0
    return recmag(n, i)

proc solve*(input: string): Answer =
    let lines = toSeq(lines input)
    result.part1 = addlist(lines).magnitude

    let ns = lines.mapIt(it.parse)
    for i in 0..ns.high:
        for j in 0..ns.high:
            if i == j: continue
            var a = ns[i]
            a += ns[j]
            a.reduce
            let m = a.magnitude
            if m > result.part2:
                result.part2 = m

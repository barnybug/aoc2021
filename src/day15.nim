import common, heapqueue, sequtils, strformat

type Item = object
    risk: uint16
    x, y: int

proc `<`(a, b: Item): bool = a.risk < b.risk

proc compute(risks: seq[seq[uint8]]): int =
    var best: seq[seq[uint16]]
    for y in 0..risks.high:
        best.add repeat(9999'u16, risks.len)

    let size = risks.len
    best[0][0] = 0
    var q = initHeapQueue[Item]()
    q.push(Item(risk: 0, x: 0, y: 0))
    while q.len > 0:
        let item = q.pop()
        for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            let (nx, ny) = (item.x+dx, item.y+dy)
            if nx >= 0 and nx < size and ny >= 0 and ny < size:
                let risk = item.risk + uint16(risks[ny][nx])
                # echo &"{nx},{ny} {risk} {best[ny][nx]}"
                if risk < best[ny][nx]:
                    best[ny][nx] = risk
                    q.push(Item(risk: risk, x: nx, y: ny))
    return int(best[size-1][size-1])

proc solve*(input: string): Answer =
    var small: seq[seq[uint8]]
    for line in lines input:
        let row = line.mapIt(uint8(ord(it)-ord('0')))
        small.add row

    let size = small.len
    var big: seq[seq[uint8]]
    for y in 0..<(size*5):
        var row: seq[uint8]
        for x in 0..<(size*5):
            let s = int(small[y mod size][x mod size]) + (x div size) + (y div size)
            let risk = uint8(((s-1) mod 9) + 1)
            row.add risk
        big.add row

    result.part1 = compute(small)
    result.part2 = compute(big)

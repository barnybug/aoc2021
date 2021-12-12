import common, bitops, strutils, tables

type Edge = uint8
type EdgeSet = uint16
type Edges = seq[EdgeSet]

proc traverse(current: Edge, edges: Edges, lower: EdgeSet, visited: EdgeSet, revisit: bool): int =
    if current == 1: # end
        return 1

    let newVisited = (visited or EdgeSet(1 shl current)) and lower
    var nexts = if revisit: edges[current] else: edges[current] and not visited
    var next: Edge = 1
    while nexts > 0:
        if nexts.testBit(1):
            result += traverse(next, edges, lower, newVisited, revisit and not visited.testBit(next))
        nexts = nexts shr 1
        inc next

proc solve*(input: string): Answer =
    var lookup = {"start": Edge(0), "end": Edge(1)}.toTable
    var lower: EdgeSet
    var next: Edge = 1
    var edges: Edges = newSeq[EdgeSet](2)

    proc edgeLookup(s: string): EdgeSet =
        if s notin lookup:
            inc next
            lookup[s] = next
            if s[0].isLowerAscii:
                lower.setBit(next)
            edges.add(0)
        result = lookup[s]

    for line in lines input:
        let parts = line.split("-")
        let (a, b) = (edgeLookup(parts[0]), edgeLookup(parts[1]))
        if b != 0: edges[a].setBit(b)
        if a != 0: edges[b].setBit(a)

    result.part1 = traverse(0, edges, lower, 0, false)
    result.part2 = traverse(0, edges, lower, 0, true)

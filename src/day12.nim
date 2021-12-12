import common, bitops, strutils, tables

type Edge = uint
type EdgeSet = uint16
type Edges = Table[Edge, seq[Edge]]

proc traverse(current: Edge, edges: Edges, lower: EdgeSet, visited: EdgeSet, revisit: bool): int =
    if current == 1: # end
        return 1
    var newVisited = visited
    if lower.testBit(current):
        newVisited.setBit(current)
    for next in edges[current]:
        if not visited.testBit(next):
            result += traverse(next, edges, lower, newVisited, revisit)
        elif revisit:
            result += traverse(next, edges, lower, newVisited, false)

proc solve*(input: string): Answer =
    var lookup = {"start": Edge(0), "end": Edge(1)}.toTable
    var lower: EdgeSet
    var next: Edge = 1
    var edges: Edges

    proc edgeLookup(s: string): Edge =
        if s notin lookup:
            inc next
            lookup[s] = next
        result = lookup[s]
        if result notin edges:
            edges[result] = @[]
        if s[0].isLowerAscii:
            lower.setBit(result)

    for line in lines input:
        let parts = line.split("-")
        let (a, b) = (edgeLookup(parts[0]), edgeLookup(parts[1]))
        if b != 0: edges[a].add(b)
        if a != 0: edges[b].add(a)

    result.part1 = traverse(0, edges, lower, 0, false)
    result.part2 = traverse(0, edges, lower, 0, true)

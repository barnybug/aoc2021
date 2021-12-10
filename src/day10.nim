import algorithm, common, tables

let scores = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
let pairs = {'(': ')', '[': ']', '{': '}', '<': '>'}.toTable
let points = {')': 1, ']': 2, '}': 3, '>': 4}.toTable

proc solve*(input: string): Answer =
    var completes: seq[int]
    for line in lines input:
        var stack: seq[char]
        var corrupted = false
        for c in line:
            case c
            of '(', '[', '{', '<':
                stack.add c
            else:
                if c != pairs[stack[^1]]:
                    result.part1 += scores[c]
                    corrupted = true
                    break
                discard stack.pop()

        if not corrupted:
            var complete = 0
            while stack.len > 0:
                let b = pairs[stack.pop()]
                complete = complete * 5 + points[b]
            completes.add complete

    completes.sort()
    result.part2 = completes[completes.len div 2]

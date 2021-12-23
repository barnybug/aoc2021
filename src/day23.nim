import common, heapqueue, sequtils, strformat, tables

#############
#89.0.1.2.34#
###1#3#5#7###
# #0#2#4#6#
# #########
type State = array[15, char]

proc parse(input: string): State =
    let lines = input.readLines(4)
    result[0] = lines[3][3]
    result[1] = lines[2][3]
    result[2] = lines[3][5]
    result[3] = lines[2][5]
    result[4] = lines[3][7]
    result[5] = lines[2][7]
    result[6] = lines[3][9]
    result[7] = lines[2][9]

proc `$`(state: State): string =
    let s = state.mapIt(if it == '\0': '.' else: it)
    return &"#############\n#{s[8]}{s[9]}.{s[10]}.{s[11]}.{s[12]}.{s[13]}{s[14]}#\n###{s[1]}#{s[3]}#{s[5]}#{s[7]}###\n  #{s[0]}#{s[2]}#{s[4]}#{s[6]}#\n  #########"

let target = ['A','A','B','B','C','C','D','D']

proc weight(c: char): int =
    case c
    of 'A': 1
    of 'B': 10
    of 'C': 100
    else: 1000

proc complete(s: State): bool =
    s[0..7] == target

let costs = [[4,3,3,5,7,9,10],[3,2,2,4,6,8,9],
    [6,5,3,3,5,7,8],[5,4,2,2,4,6,7],
    [8,7,5,3,3,5,6],[7,6,4,2,2,4,5],
    [10,9,7,5,3,3,4],[9,8,6,4,2,2,3]]

type Item = tuple[state: State, cost: int]

proc `<`(a, b: Item): bool = a.cost < b.cost

proc solve*(input: string): Answer =
    let initial = input.parse
    var q = initHeapQueue[Item]()
    var memo: Table[State, int]
    q.push((initial, 0))
    var best = 99999999
    while q.len > 0:
        let (s, cost) = q.pop()
        if s in memo and memo[s] < cost: continue

        var done = false

        # move from hallway
        for i in 8..14:
            let c = s[i]
            if c == '\0':
                continue # nothing

            if i == 8 and s[9] != '\0': continue
            if i == 14 and s[13] != '\0': continue

            let t = if c == 'A': [0, 1]
            elif c == 'B': [2, 3]
            elif c == 'C': [4, 5]
            else: [6, 7]
            for j in t:
                if s[j] != '\0': continue # occupied
                let bottom = (j mod 2) == 0
                if not bottom:
                    if s[j-1] == '\0': continue # don't move to top if bottom empty
                    if s[j-1] != c: continue # don't move into one occupied by different
                #############
                #89.0.1.2.34#
                ###1#3#5#7###
                # #0#2#4#6#
                # #########
                if i < 10 and j > 1 and s[10] != '\0': continue
                if i < 11 and j > 3 and s[11] != '\0': continue
                if i < 12 and j > 5 and s[12] != '\0': continue

                if i > 12 and j < 6 and s[12] != '\0': continue
                if i > 11 and j < 4 and s[11] != '\0': continue
                if i > 10 and j < 2 and s[10] != '\0': continue

                # Valid move!
                let ncost = cost + costs[j][i-8]*weight(c)

                var ns = s
                ns[j] = ns[i]
                ns[i] = '\0'
                if ncost >= best:
                    continue
                if ns.complete:
                    best = ncost
                else:
                    if memo.getOrDefault(ns, 99999) > ncost:
                        memo[ns] = ncost
                        q.push (ns, ncost)
                done = true
                break

        if done:
            continue

        # move from room
        for i in 0..7:
            let c = s[i]
            if c == '\0':
                continue # nothing
            let bottom = (i mod 2) == 0
            if bottom:
                if c == target[i]:
                    continue # finished
                if s[i+1] != '\0':
                    continue # blocked by one above
            else:
                if c == target[i] and s[i-1] == target[i]:
                    continue # finished (not blocking another under)
            # Good to move, where to...
            #############
            #89.0.1.2.34#
            ###1#3#5#7###
            # #0#2#4#6#
            # #########
            for j in 8..14:
                if s[j] != '\0': continue # occupied
                if j == 8 or j == 9:
                    # left hallway
                    if j == 8 and s[9] != '\0': continue
                    if i > 1 and s[10] != '\0': continue
                    if i > 3 and s[11] != '\0': continue
                    if i > 5 and s[12] != '\0': continue
                elif j == 10:
                    # 1st hallway
                    if i > 3 and s[11] != '\0': continue
                    if i > 5 and s[12] != '\0': continue
                elif j == 11:
                    # 2nd hallway
                    if i < 2 and s[10] != '\0': continue
                    if i > 5 and s[12] != '\0': continue
                elif j == 12:
                    # 3rd hallway
                    if i < 2 and s[10] != '\0': continue
                    if i < 4 and s[11] != '\0': continue
                elif j == 13 or j == 14:
                    # right hallway
                    if j == 14 and s[13] != '\0': continue
                    if i < 6 and s[12] != '\0': continue
                    if i < 4 and s[11] != '\0': continue
                    if i < 2 and s[10] != '\0': continue
                
                # Valid move!
                let ncost = cost + costs[i][j-8]*weight(c)
                var ns = s
                ns[j] = ns[i]
                ns[i] = '\0'
                if ncost >= best:
                    continue
                if memo.getOrDefault(ns, 99999) > ncost:
                    memo[ns] = ncost
                    q.push (ns, ncost)

    result.part1 = best
    result.part2 = 0

import common, hashes, heapqueue, sequtils, strformat, strutils, tables

#############
#01.2.3.4.56#
###0#1#2#3###
# #0#1#2#3#
# #########
type Pod = enum A = 0, B = 1 , C = 2, D = 3, Empty = 4, Wall = 5
type State = object
    hall: array[7, Pod]
    rooms: array[4,array[4, Pod]]

proc hash(s: State): Hash = hash(s.hall) !& hash(s.rooms)

proc parse(input: string): State =
    let lines = toSeq(input.lines)
    for i in result.hall.mitems: i = Empty
    for i in 0..3:
        for j in 0..3:
            let y = if j+2 > lines.high: j + 1 else: j + 2
            result.rooms[i][j] = case lines[y][i*2+3]
            of 'A': A
            of 'B': B
            of 'C': C
            of 'D': D
            of '.': Empty
            else: Wall

proc `$`(state: State): string =
    let h = state.hall
    let r = state.rooms
    result = &"#############\n#{h[0]}{h[1]}.{h[2]}.{h[3]}.{h[4]}.{h[5]}{h[6]}#\n"
    for i in 0..3:
        if r[0][i] == Wall: break
        result &= &"  #{r[0][i]}#{r[1][i]}#{r[2][i]}#{r[3][i]}#\n"
    result &= "  #########"
    result = result.replace("Empty", ".")

proc weight(p: Pod): int =
    case p
    of A: 1
    of B: 10
    of C: 100
    else: 1000

proc complete(state: State): bool =
    for i, room in state.rooms:
        for j in room:
            if j == Wall:
                break
            if j != Pod(i):
                return false
    return true

type Item = tuple[state: State, cost: int]

proc `<`(a, b: Item): bool = a.cost < b.cost

proc ready(room: array[4, Pod], p: Pod): bool = room.allIt(it == Empty or it == Wall or it == p)

proc top(room: array[4, Pod]): (Pod, int) = 
    for i in 0..3:
        if room[i] != Empty and room[i] != Wall: return (room[i], i)

proc add(room: var array[4, Pod], c: Pod): int =
    for i in countdown(3, 0):
        if room[i] != Empty: continue
        room[i] = c
        return i

let hall_to_room_steps = [[2,4,6,8], [1,3,5,7], [1,1,3,5], [3,1,1,3], [5,3,1,1], [7,5,3,1], [8,6,4,2]]

proc compute(input: string): int =
    let initial = input.parse
    var q = initHeapQueue[Item]()
    var memo: Table[State, int]
    q.push((initial, 0))
    var best = 99999999
    while q.len > 0:
        var (state, cost) = q.pop()
        if state in memo and memo[state] < cost: continue

        # first move everything from hallway to final that's possible (always min)
        var check = true
        while check:
            check = false
            for h, c in state.hall:
                if c == Empty: continue
                let r = int(c)
                if not ready(state.rooms[r], c):
                    continue
                var clear = true
                if h-r < 2: # moving right
                    for j in (h+1)..(r+1):
                        if state.hall[j] != Empty:
                            clear = false
                            break
                else: # moving left
                    for j in (r+2)..(h-1):
                        if state.hall[j] != Empty:
                            clear = false
                            break
                if not clear:
                    continue
                # move
                # echo state
                # echo "valid ", h, "->", r
                state.hall[h] = Empty
                let at = add(state.rooms[r], c)
                # echo state
                #############
                #01.2.3.4.56#
                ###0#1#2#3###
                # #0#1#2#3#
                # #########
                # let x = (hall_to_room_steps[h][r] + at + 1) * weight(c)
                # echo hall_to_room_steps[h][r]
                # echo at
                # echo "cost: ", x
                cost += (hall_to_room_steps[h][r] + at + 1) * weight(c)
                
                check = true # rerun

        # check for completion
        if state.complete:
            if cost < best:
                best = cost
            continue # next in deque

        # necessary?
        if memo.getOrDefault(state, 99999) > cost:
            memo[state] = cost

        # moves from room to hall
        # echo state
        for r in 0..3:
            # echo "r", r
            let pod = Pod(r)
            if ready(state.rooms[r], pod):
                continue
            let (c, at) = top(state.rooms[r])
            # echo "c", c, "at", at
            for h in 0..6:
                # echo "h", h
                var clear = true
                if h-r >= 2: # moving right
                    for j in (r+2)..h:
                        if state.hall[j] != Empty:
                            clear = false
                            break
                else: # moving left
                    for j in h..(r+1):
                        if state.hall[j] != Empty:
                            clear = false
                            break
                if not clear:
                    continue
                # Valid move -> room to hall
                let ncost = cost + (hall_to_room_steps[h][r] + at + 1) * weight(c)
                var ns = state
                ns.hall[h] = c
                ns.rooms[r][at] = Empty
                # echo state
                # echo "valid: ", r, "->", h
                # echo ns
                # echo "cost: ", cost, "->", ncost
                if ncost >= best: # no point exploring - worse than best completed
                    continue
                if memo.getOrDefault(ns, 99999) > ncost:
                    memo[ns] = ncost
                    q.push (ns, ncost)
    return best

proc solve*(input: string): Answer =
    
    result.part1 = compute(input)
    result.part2 = compute("input23b.txt")

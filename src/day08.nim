import algorithm, common, re, sequtils, tables

proc toBin(s: string): int =
    for c in s:
        result += 1 shl (ord(c) - ord('a'))

proc solve*(input: string): Answer =
    for line in lines input:
        let parts = line.split(re"[^a-z]+")
        var segs = parts[0..9]
        let output = parts[^4..^1]

        # part 1
        for seg in output:
            if seg.len in [2, 3, 4, 7]:
                inc result.part1

        # part 2
        proc byLen(x, y: string): int =
            cmp(x.len, y.len)
        segs.sort(byLen)
        # lens:   2 3 4 5 5 5 6 6 6 7
        # digits: 1 7 4[2 5 3|0 6 9]8
        # index:  0 1 2 3 4 5 6 7 8 9
        let bits = segs.map(toBin)
        # known 1, 4, 7 and 8
        var fwd = [0, bits[0], 0, 0, bits[2], 0, 0, bits[1], bits[9], 0]
        # 3 is the only one in group 2,3,5 matching on 1
        for i in [3, 4, 5]:
            if (bits[i] and bits[0]) == bits[0]:
                fwd[3] = bits[i]
        # 9 is 3|4
        fwd[9] = fwd[3] or fwd[4]
        # 6 is the only one not in group 0,6,9 matching on 1
        for i in [6, 7, 8]:
            if (bits[i] and bits[0]) != bits[0]:
                fwd[6] = bits[i]
        # 0 is the only left in 0,6,9 group
        for i in [6, 7, 8]:
            if bits[i] notin fwd:
                fwd[0] = bits[i]
        # 5 is 6&9
        fwd[5] = fwd[6] and fwd[9]
        # 2 is the only left in 2,3,5 group
        for i in [3, 4, 5]:
            if bits[i] notin fwd:
                fwd[2] = bits[i]
        var bk: Table[int, int] # from bitwise->actual number
        for key, value in fwd:
            bk[value] = key

        let bout = output.map(toBin)
        let decoded = 1000*bk[bout[0]] + 100*bk[bout[1]] + 10*bk[bout[2]] + bk[bout[3]]
        result.part2 += decoded

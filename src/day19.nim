import common, sequtils, sets, strscans, strutils

type Point = (int, int, int)
type Scanner = seq[Point]

proc `+`(a, b: Point): Point = (a[0]+b[0], a[1]+b[1], a[2]+b[2])
proc `-`(a, b: Point): Point = (a[0]-b[0], a[1]-b[1], a[2]-b[2])

proc mag(a: Point): int = a[0]*a[0] + a[1]*a[1] + a[2]*a[2]
proc manhattan(a: Point): int = abs(a[0]) + abs(a[1]) + abs(a[2])

proc parse(input: string): seq[Scanner] =
    var scanner: seq[Point]
    for line in input.lines:
        if line == "":
            result.add scanner
            scanner = newSeq[Point]()
        elif line.startsWith("---"):
            continue
        else:
            var x, y, z: int
            assert line.scanf("$i,$i,$i", x, y, z)
            scanner.add (x, y, z)

    if scanner.len > 0:
        result.add scanner

proc reorientX(p: Point, i: int): Point =
    # i = 0..5
    case i
    of 0: return p
    of 1: return (p[1], -p[0], p[2])
    of 2: return (-p[0], -p[1], p[2])
    of 3: return (-p[1], p[0], p[2])
    of 4: return (-p[2], p[1], p[0])
    else: return (p[2], p[1], -p[0])

proc rotX(p: Point, i: int): Point =
    # i = 0..3
    case i
    of 0: return p
    of 1: return (p[0], -p[2], p[1])
    of 2: return (p[0], -p[1], -p[2])
    else: return (p[0], p[2], -p[1])

proc transform(p: Point, i: int): Point =
    result = p.rotX(i mod 4).reorientX(i div 4)


type Fingerprint = object
    scanner: Scanner
    sets: seq[HashSet[int]]
    all: HashSet[int]

proc fingerprint(s: Scanner): Fingerprint =
    result.scanner = s
    for p0 in s:
        let st = s.filterIt(it != p0).mapIt((it-p0).mag).toHashSet
        result.sets.add st
        result.all.incl(st)

proc overlap(s0, s1: Fingerprint): (Fingerprint, Point) =
    # don't bother comparing if there's no possibility of overlaps
    if s0.all.disjoint(s1.all) or (s0.all * s1.all).len < 11:
        return
    for i, p0 in s0.scanner:
        let fp1 = s0.sets[i]
        for j, p1 in s1.scanner:
            let fp2 = s1.sets[j]
            if not fp1.disjoint(fp2) and (fp1 * fp2).len >= 11:
                # p0 == p1, but don't know rotation/translation
                let hs0 = s0.scanner.toHashSet
                for t in 0..23:
                    let translate = p0 - p1.transform(t)
                    let rs1 = s1.scanner.mapIt(it.transform(t) + translate)
                    let hs1 = rs1.toHashSet
                    if (hs0.intersection(hs1)).len >= 12:
                        return (rs1.fingerprint, translate)
                echo "False positive"

proc solve*(input: string): Answer =
    var scanners = parse(input)
    var all = scanners[0].toHashSet
    var transforms: seq[Point]

    # precompute fingerprint
    var fingerprints = scanners.mapIt(it.fingerprint)
    var matched = fingerprints[0..0]
    var unmatched = fingerprints[1..^1]

    # find pairs of overlapping scanners
    var i = 0
    while i < matched.len:
        let s0 = matched[i]
        var next_unmatched: seq[Fingerprint]
        for j, s1 in unmatched:
            let (ns1, tr) = overlap(s0, s1)
            if ns1.scanner.len > 0:
                # echo "Match ", i, " ", j
                matched.add ns1
                all.incl ns1.scanner.toHashSet
                transforms.add(tr)
            else:
                next_unmatched.add s1

        unmatched = next_unmatched
        inc i
    assert matched.len == scanners.len
    assert unmatched.len == 0

    var max_dist = 0
    for i, t1 in transforms:
        for t2 in transforms[i+1..^1]:
            let dist = (t1 - t2).manhattan
            if dist > max_dist:
                max_dist = dist
    result.part1 = all.len
    result.part2 = max_dist

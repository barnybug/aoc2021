import common, strscans, strformat

# vi = sum(0, n, v0-i)
# yi = sum(0, n, y(i-1)+vi)
# yi = sum(0, n, v0-i)

proc triangle(n: int): int = n * (n+1) div 2

proc solve*(input: string): Answer =
    let text = input.readFile
    var x1, x2, y1, y2: int
    assert text.scanf("target area: x=$i..$i, y=$i..$i", x1, x2, y1, y2)

    var farthest = 0
    for h in 1..x2:
        farthest += h
        if farthest < x1:
            continue
        for v in y1..x2:
            var x = 0
            var y = 0
            for i in 1..1000:
                y += v - i + 1
                if i <= h:
                    x += h - i + 1
                if x < x1 or y > y2:
                    continue
                if x > x2 or y < y1:
                    break
                var max_y = v.triangle
                if max_y > result.part1:
                    result.part1 = max_y
                inc result.part2
                break

import re, strformat, strutils

type Answer* = tuple[part1: int, part2: int]

proc `$`*(answer: Answer): string = &"Part 1: {answer.part1}\nPart 2: {answer.part2}"

proc parseIntList*(s: string): seq[int] =
    for n in s.strip.split(re"\D+"):
        result.add parseInt(n)

import algorithm, common, os, sequtils, strformat, strutils, tables
import day01, day02, day03, day04

var SOLUTIONS*: Table[int, proc (input: string): Answer]

SOLUTIONS[1] = day01.solve
SOLUTIONS[2] = day02.solve
SOLUTIONS[3] = day03.solve
SOLUTIONS[4] = day04.solve

when isMainModule:
  let params = os.commandLineParams()

  let days = if len(params) == 0:
    toSeq(SOLUTIONS.keys).sorted
  else:
    params.map(parseInt).toSeq
  
  for day in days:
    echo fmt"Day {day}:"
    let input = fmt"input{day:02}.txt"
    echo SOLUTIONS[day](input)

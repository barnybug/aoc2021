import common, day01, os

when isMainModule:
  let params = os.commandLineParams()
  if "1" in params or len(params) == 0:
    echo "Day 1:"
    echo day01.solve("input01.txt")

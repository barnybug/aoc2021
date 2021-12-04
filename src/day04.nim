import common, sequtils, strutils

type Board = array[5, array[5, int]]
type Mark = array[5, array[5, bool]]

proc contains(b: Board, number: int): (bool, int, int) =
    for y, row in b.pairs:
        let x = row.find(number)
        if x > -1:
            return (true, x, y)

proc winner(mark: Mark): bool =
    for row in mark:
        if row.find(false) == -1:
            return true

    for col in 0..4:
        if all(mark, proc (row: array[5, bool]): bool = row[col]):
            return true

iterator fillBoards(boards: seq[Board], numbers: seq[int]): int =
    var marks = newSeq[Mark](boards.len)
    var done = newSeq[bool](boards.len)
    for number in numbers:
        for b, board in boards.pairs:
            if done[b]:
                continue
            let (present, x, y) = board.contains(number)
            if present:
                marks[b][y][x] = true
                if winner(marks[b]):
                    var unmarked = 0
                    for (ns, ms) in zip(board, marks[b]):
                        for (n, m) in zip(ns, ms):
                            if not m: unmarked += n
                    done[b] = true
                    yield unmarked * number

proc solve*(input: string): Answer =
    let parts = input.readFile.split("\n\n")
    let numbers = parts[0].split(",").mapIt(parseInt(it))

    var boards: seq[Board]
    for part in parts[1..^1]:
        var board: Board
        for y, line in part.split("\n").pairs():
            let row = parseIntList(line)
            for x, n in row:
                board[y][x] = n
        boards.add board

    let scores = toSeq(fillBoards(boards, numbers))
    result.part1 = scores[0]
    result.part2 = scores[^1]

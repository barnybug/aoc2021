import common, bitops, math, sequtils, strformat, strutils

type TypeID* {.pure.} = enum
    sum, product, min, max, literal, gt, lt, eq

type Packet = object
    version*: int
    typeID*: TypeID
    literal*: uint64
    subpackets*: seq[Packet]

type BitStream = object
    data: seq[uint8]
    offset: int

proc newBitStream*(s: string): BitStream =
    result.data = newSeqUninitialized[uint8](s.len)
    for i in 0..s.high:
        result.data[i] = fromHex[uint8](s[i..i])

proc readOne(bits: var BitStream): uint8 =
    result = uint8(bits.data[bits.offset div 4].testBit(3 - (bits.offset mod 4)))
    inc bits.offset

proc readN(bits: var BitStream, n: int): uint64 =
    for i in 1..n:
        result = result shl 1 + readOne(bits)

proc `$`*(p: Packet): string = &"v:{p.version} t:{p.typeID}"

proc parse*(bits: var BitStream): Packet =
    result.version = int(bits.readN(3))
    result.typeID = TypeID(bits.readN(3))
    if result.typeID == TypeID.literal:
        var more = true
        var literal: uint64 = 0
        while more:
            more = bits.readOne == 1
            literal = literal shl 4 + bits.readN(4)
        result.literal = literal
    else: # operator
        if bits.readOne() == 0: # length encoded
            let length = bits.readN(15)
            let limit = bits.offset + int(length)
            while bits.offset < limit:
                let subpacket = parse(bits)
                result.subpackets.add subpacket
        else: # count
            let number = bits.readN(11)
            for i in 1..number:
                let subpacket = parse(bits)
                result.subpackets.add subpacket

proc versionSum*(p: Packet): int =
    result = p.version
    if p.typeID != TypeID.literal:
        for s in p.subpackets:
            result += s.versionSum

proc evaluate*(p: Packet): uint64 =
    let children = p.subpackets.mapIt(it.evaluate)
    case p.typeID
    of TypeID.sum:
        result = children.sum
    of TypeID.product:
        result = children.prod
    of TypeID.min:
        result = children.min
    of TypeID.max:
        result = children.max
    of TypeID.gt:
        result = if children[0] > children[1]: 1 else: 0
    of TypeID.lt:
        result = if children[0] < children[1]: 1 else: 0
    of TypeID.eq:
        result = if children[0] == children[1]: 1 else: 0
    of TypeID.literal:
        result = p.literal

proc solve*(input: string): Answer =
    let s = input.readFile.strip
    var bs = newBitStream(s)
    let p = parse(bs)

    result.part1 = p.versionSum
    result.part2 = int(p.evaluate)

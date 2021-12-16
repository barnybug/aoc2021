import unittest
import day16

suite "day 16":
  test "part 1":
    var bs1 = newBitStream("D2FE28")
    let packet1 = day16.parse(bs1)
    check packet1.version == 6
    check packet1.typeID == TypeID.literal
    check packet1.literal == 2021

    var bs2 = newBitStream("38006F45291200")
    let packet2 = day16.parse(bs2)
    check packet2.version == 1
    check packet2.typeID == TypeID.lt
    check packet2.subpackets.len == 2
    check packet2.subpackets[0].literal == 10
    check packet2.subpackets[1].literal == 20

    var bs3 = newBitStream("EE00D40C823060")
    let packet3 = day16.parse(bs3)
    check packet3.version == 7
    check packet3.typeID == TypeID.max
    check packet3.subpackets.len == 3
    check packet3.subpackets[0].literal == 1
    check packet3.subpackets[1].literal == 2
    check packet3.subpackets[2].literal == 3

    var bs4 = newBitStream("8A004A801A8002F478")
    let packet4 = day16.parse(bs4)
    check packet4.versionSum == 16

    var bs5 = newBitStream("620080001611562C8802118E34")
    let packet5 = day16.parse(bs5)
    check packet5.versionSum == 12

    var bs6 = newBitStream("C0015000016115A2E0802F182340")
    let packet6 = day16.parse(bs6)
    check packet6.versionSum == 23

    var bs7 = newBitStream("A0016C880162017C3686B18A3D4780")
    let packet7 = day16.parse(bs7)
    check packet7.versionSum == 31


  test "part 2":
    for (s, expected) in [("C200B40A82", 3), ("04005AC33890", 54), ("880086C3E88112", 7), ("CE00C43D881120", 9), ("D8005AC2A8F0", 1), ("F600BC2D8F", 0), ("9C005AC2F8F0", 0), ("9C0141080250320F1802104A08", 1)]:
      var bs1 = newBitStream(s)
      let packet1 = day16.parse(bs1)
      check packet1.evaluate == uint32(expected)

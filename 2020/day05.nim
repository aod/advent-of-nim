import std/[strformat, sequtils]
when IsPart2:
  import std/[math]

type
  BoardingPass = string
  SeatID = int

func seatID(pass: BoardingPass): SeatID =
  pass.multiReplace(("F", "0"), ("B", "1"), ("L", "0"), ("R", "1")).parseBinInt

func parse(input: string): seq[SeatID] =
  input.splitLines.map seatID

func solve(input: string): SeatID =
  let ids = input.parse
  when IsPart1:
    ids.max
  else:
    (ids.min .. ids.max).toSeq.sum - ids.sum

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

  static:
    when IsPart1:
      assert "FBFBBFFRLR".solve == 357
      assert "BFFFBBFRRR".solve == 567
      assert "FFFBBBFRRR".solve == 119
      assert "BBFFBBFRLL".solve == 820

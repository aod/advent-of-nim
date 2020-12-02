import std/[sequtils, math]

const Entries = when IsPart1: 2 else: 3
const SumTarget = 2020

proc solve(input: string): int =
  let expenses = input.splitLines.toSeq.map parseInt
  for xs in expenses.comb Entries:
    if xs.sum == SumTarget:
      return xs.prod
  quit &"Could not find {Entries} entries that sum to {SumTarget}"

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

  static:
    const example = """1721
979
366
299
675
1456"""

    when IsPart1:
      assert example.solve == 514579
    else:
      assert example.solve == 241861950

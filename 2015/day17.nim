import std/[math, sequtils]

proc solve(input: string): int =
  var xs = input.splitLines.map(parseInt)
  for i in 1..xs.len:
    for ys in xs.comb(i):
      if ys.sum == 150:
        result += 1
    when IsPart2:
      if result > 0:
        break

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

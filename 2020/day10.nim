import std/[sequtils, algorithm]
when IsPart2: import std/tables


proc solve(input: string): int =
  var xs = input.splitLines.toSeq.map parseInt
  xs.sort()
  xs.insert(0, 0)

  when IsPart1:
    var diff = (0, 1)
    for pair in xs.partial(2):
      case pair[1] - pair[0]:
      of 1: diff[0] += 1
      of 3: diff[1] += 1
      else: discard
    diff[0] * diff[1]
  else:
    var ct = initCountTable[int]()
    ct[0] = 1
    for x in xs:
      for y in [x+1, x+2, x+3]:
        ct.inc(y, ct[x])
    ct[xs[^1] + 3]


when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

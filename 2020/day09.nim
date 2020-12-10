import std/[sequtils, deques]


proc isValid(t: int; xs: Deque[int]): bool =
  for i, x in xs.pairs:
    for j, y in xs.pairs:
      if i != j and x + y == t:
        return true


proc solve(input: string): int =
  var xs = input.splitLines.toSeq.map parseInt

  var preamble = xs[0 ..< 25].toDeque
  for x in xs[25 .. ^1]:
    if not x.isValid(preamble):
      result = x
      when IsPart1:
        return
    preamble.popFirst
    preamble.addLast x

  when IsPart2:
    for i, x in xs.pairs:
      var processed = 0;
      var sum = x
      for y in xs[i + 1 .. ^1]:
        if sum == result:
          let mm = xs[i .. i + processed]
          return mm.min + mm.max
        sum += y
        processed += 1


when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

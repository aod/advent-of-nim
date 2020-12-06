import std/[parseutils, sets]
when IsPart2: import std/[sugar, sequtils]

proc solve(input: string): int =
  var cursor = 0

  while cursor < input.len:
    var group: string
    cursor += parseUntil(input, group, "\n\n", cursor) + 1

    when IsPart1:
      result += (group.toHashSet - "\n".toHashSet).len
    else:
      result += group.strip.splitLines.map(line => line.toHashSet)
        .foldl(a * b, "abcdefghijklmnopqrstuvwxyz".toHashSet)
        .len

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

  static:
    const example = """abc

a
b
c

ab
ac

a
a
a
a

b"""
    when IsPart1:
      assert example.solve == 11
    else:
      assert example.solve == 6

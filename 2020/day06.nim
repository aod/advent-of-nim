import std/[parseutils, sets]

proc solve(input: string): int =
  var cursor = 0

  while cursor <= input.high:
    var group: string
    var nParsed = parseUntil(input, group, "\n\n", cursor)
    defer: cursor += nParsed + 1

    when IsPart1:
      var unique = group.toHashSet
      unique.excl('\n')
      result += unique.len
    else:
      var unique = "abcedfghijklmnopqrstuvwxyz".toHashSet
      for line in input[cursor ..< cursor + nParsed].strip.splitLines:
        unique = unique * line.toHashSet
      result += unique.len

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

import std/[parseutils, tables]

const MyAunt = {
  "children": 3,
  "cats": 7,
  "samoyeds": 2,
  "pomeranians": 3,
  "akitas": 0,
  "vizslas": 0,
  "goldfish": 5,
  "trees": 3,
  "cars": 2,
  "perfumes": 1}.toTable

proc solve(input: string): int =
  for line in input.splitLines:
    var i = skipUntil(line, Digits)

    var sue: string
    i += parseUntil(line, sue, ':', i)
    i += skipUntil(line, Letters, i)

    var isMyAunt = true
    defer:
      if isMyAunt:
        return sue.parseInt

    while i < line.high:
      var key: string
      i += parseUntil(line, key, ':', i)
      i += skipUntil(line, Digits, i)

      var num: int
      i += parseInt(line, num, i)
      i += skipUntil(line, Letters, i)

      let aVal = MyAunt[key]
      let valid = when IsPart1:
        num == aVal
      else:
        case key:
        of "cats", "trees": num > aVal
        of "pomeranians", "goldfish": num < aVal
        else: num == aVal

      if not valid:
        isMyAunt = false
        break

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

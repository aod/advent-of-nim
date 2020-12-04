import std/[strscans, sequtils]

type
  Record = object
    policy: (int, int)
    letter: char
    password: string

proc parse(s: string): Record =
  const p = "$i-$i $w: $w$."
  var l: string
  discard scanf(s, p, result.policy[0],
                      result.policy[1],
                      l,
                      result.password)
  # FIXME: this is hackish
  result.letter = l[0]

proc solve(input: string): int =
  for record in input.splitLines.map parse:
    let policy = record.policy
    when IsPart1:
      let sum = record.password.count(record.letter)
      if sum >= policy[0] and sum <= policy[1]:
        result += 1
    else:
      if record.password[policy[0] - 1] == record.letter xor
         record.password[policy[1] - 1] == record.letter:
        result += 1

when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

  static:
    const example = """1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc"""

    when IsPart1:
      assert example.solve == 2
    else:
      assert example.solve == 1

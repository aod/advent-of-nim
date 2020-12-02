import std/[strscans, sequtils]

type
  Record = object
    policy: tuple[min, max: int]
    letter: char
    password: string

proc parse(s: string): Record =
  const p = "$i-$i $w: $w$."
  var l: string
  discard scanf(s, p, result.policy.min,
                      result.policy.max,
                      l,
                      result.password)
  result.letter = l[0]

proc solve(input: string): int =
  var records = input.splitLines.toSeq.map parse
  for record in records:
    let (min, max) = record.policy
    when IsPart1:
      var sum = record.password.count(record.letter)
      if sum >= min and sum <= max:
        result += 1
    else:
      let valid = (record.password[min - 1] == record.letter,
                   record.password[max - 1] == record.letter)
      if valid == (true, false) or valid == (false, true):
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

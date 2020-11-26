import std/[options, math]
export options

const IsPart2* = defined(part2)
const IsPart1* = not IsPart2
const Part* = if IsPart1: 1 else: 2

iterator partial*[T](s: openArray[T], n: Positive = 3): seq[T] =
  for i in s.low .. s.len - n:
    yield s[i ..< i + n]

func hasStraightIncrease*[T: Ordinal](xs: openArray[T]): bool =
  for x in xs.partial(2):
    if ord(x[1]) - ord(x[0]) != 1:
      return false
  true

func neighbours*[T](xs: openArray[T], index: int): tuple[left, right: Option[T]] =
  if xs.len > 0:
    return (some(xs[floorMod(index - 1, xs.len)]),
            some(xs[floorMod(index + 1, xs.len)]))

template doWhile*(cond: typed, body: typed) =
  body
  while cond:
    body

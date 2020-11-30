import std/[options, math, strformat, strutils]
export options, strformat, strutils

const IsPart2* = defined(part2)
const IsPart1* = not IsPart2
const P* = if IsPart1: 1 else: 2

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

func `+`*[T: SomeNumber](x, y: seq[T]): seq[T] =
  let (smallest, biggest) = if x.high > y.high: (y, x) else: (x, y)
  result = biggest
  for i, v in smallest.pairs:
    result[i] += v

template doWhile*(cond: typed, body: typed) =
  body
  while cond:
    body

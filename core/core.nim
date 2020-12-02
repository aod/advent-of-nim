import std/[options, strformat, strutils, math]
export options, strformat, strutils

const IsPart2* = defined(part2)
const IsPart1* = not IsPart2
const P* = if IsPart1: 1 else: 2
const OutputPrefix* = &"Part {P}: "

iterator partial*[T](s: openArray[T], n: Positive = 3): seq[T] =
  for i in s.low .. s.len - n:
    yield s[i ..< i + n]

# stolen from: http://rosettacode.org/wiki/Combinations#Nim
iterator comb*[T: Natural](m: T, n: Positive): seq[T] =
  var c = newSeq[T](n)
  for i in 0..<n: c[i] = i

  block outer:
    while true:
      yield c

      var i = n - 1
      inc c[i]
      if c[i] <= m - 1:
        continue

      while c[i] >= m - n + i:
        dec i
        if i < 0:
          break outer

      inc c[i]
      while i < n - 1:
        c[i + 1] = c[i] + 1
        inc i

iterator comb*[T](xs: openArray[T], n: Positive): seq[T] =
  var ys = newSeq[T](n)
  for c in comb(xs.len, n):
    for i in 0..<n:
      ys[i] = xs[c[i]]
    yield ys

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

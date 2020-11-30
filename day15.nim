import std/[algorithm, sequtils, sugar, strscans, strformat, strutils]
import ./core

type
  Teaspoons = int
  Score = int

  Ingredient = object
    name: string
    cap: int # capacity
    dur: int # durability
    fla: int # flavor
    txr: int # texture
    cal: int # calories

func listedProps(p: Ingredient): seq[int] =
  result = @[p.cap, p.dur, p.fla, p.txr]
  when IsPart2:
    result.add(p.cal)

func parse(properties: string): Ingredient =
  var x: Ingredient
  const pattern = "$w: capacity $i, durability $i, flavor $i, texture $i, calories $i$."
  discard scanf(properties, pattern, x.name, x.cap, x.dur, x.fla, x.txr, x.cal)
  x

proc bestCookieScore(kitchenIngredients: string): Score =
  var ingredients = kitchenIngredients.splitLines.map(x => x.parse)

  var mix: seq[seq[Score]]
  for _ in ingredients:
    mix.add(toSeq(1 ..< 100))

  for teaspoons in product(mix):
    const MaxTeaspoons: Teaspoons = 100
    if teaspoons.foldl(a + b) != MaxTeaspoons: continue

    let props = toSeq(ingredients.pairs)
      .map(pair => pair.val.listedProps.map(x => x * teaspoons[pair.key]))
      .foldl(a + b)
      .map(x => x.max(0))

    when IsPart1:
      result = result.max(props.foldl(a * b))
    else:
      const CalRequirement = 500
      if props[^1] != CalRequirement: continue
      result = result.max(props[0 ..< ^1].foldl(a * b))

when isMainModule:
  echo fmt"Part {Part}: {stdin.readAll.strip.bestCookieScore}"

  static:
    const example = """Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3"""

    when IsPart1:
      assert example.bestCookieScore == 62842880
    else:
      assert example.bestCookieScore == 57600000

import std/[parseutils, tables, strformat, sets]


type
  Color = string
  Inner = (Natural , Bag)
  Bags = seq[Inner]
  Bag = ref object
    color: Color
    bags: Option[Bags]

const ShinyGold: Color = "shiny gold"


proc parse(input: string): Table[Color, Bag] =
  for rule in input.splitLines:
    var color: Color
    var i = parseUntil(rule, color, " bags")
    var bag = result.mgetOrPut(color, Bag(color: move(color)))

    var children: Bags
    defer:
      if children.len > 0: bag.bags = some(children)

    while i < rule.len:
      i += skipUntil(rule, Digits, i)
      if i == rule.len: break

      var child: Inner
      var childColor: Color
      i += parseInt(rule, child[0], i)
      i += skipWhitespace(rule, i)
      i += parseUntil(rule, childColor, " bag", i)

      child[1] = result.mgetOrPut(childColor, Bag(color: move(childColor)))
      children.add move(child)


proc part1(bag: Bag; seen: var HashSet[Color]): int =
  if bag.color.startsWith ShinyGold: return 1
  if bag.bags.isNone: return 0
  if bag.color in seen: return 1

  for (_, child) in bag.bags.get:
    let res = part1(child, seen)
    if res > 0:
      seen.incl bag.color
      result += res


proc part2(bag: Bag): int =
  if bag.bags.isNone: return 0
  for (n, inner) in bag.bags.get:
    result += n + n * inner.part2


proc find(bag: Bag; color: Color): Bag =
  if bag.color == color: return bag
  if bag.bags.isNone: return nil

  for (_, inner) in bag.bags.get:
    let target = inner.find(color)
    if target != nil:
      return target


func createRootBag(bags: Table[Color, Bag]): Bag =
  var allInnerBags: HashSet[Color]
  for bag in bags.values:
    if bag.bags.isSome:
      for (_, child) in bag.bags.get:
        allInnerBags.incl child.color

  var outerBags: Bags
  for bag in bags.values:
    if bag.color notin allInnerBags:
      outerBags.add (Natural(1), bag)

  Bag(bags: some(outerBags))


proc solve(input: string): int =
  let root = input.parse.createRootBag

  when IsPart1:
    var seen: HashSet[Color]
    discard root.part1(seen)
    seen.len - 1
  else:
    let shinyBag = root.find(ShinyGold)
    shinyBag.part2


when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

  static:
    const example = """light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."""

    when IsPart1:
      assert example.solve == 4
    else:
      assert example.solve == 32

      const example2 = """shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."""
      assert example2.solve == 126

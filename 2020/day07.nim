import std/[parseutils, tables, strformat, sets]

type
  Bags = seq[(int, Bag)]
  Bag = ref object
    name: string
    bags: Option[Bags]


proc `$`(self: Bag): string =
  &"{self.name} -> {self.bags}"


proc parse(input: string): Table[string, Bag] =
  for rule in input.splitLines:
    var name: string
    var i = parseUntil(rule, name, " bags")
    var bag = result.mgetOrPut(name, Bag(name: move(name)))

    var children: seq[(int, Bag)]
    defer:
      if children.len > 0: bag.bags = some(children)

    while i < rule.len:
      i += skipUntil(rule, Digits, i)
      if i == rule.len: break

      var child: (int, Bag)
      var childName: string
      i += parseInt(rule, child[0], i)
      i += skipWhitespace(rule, i)
      i += parseUntil(rule, childName, " bag", i)

      child[1] = result.mgetOrPut(childName, Bag(name: move(childName)))
      children.add move(child)


proc nYellowBags(bag: Bag; memo: var HashSet[string]; name: string): int =
  if bag.name.startsWith name: return 1
  if bag.bags.isNone: return 0
  if bag.name in memo: return 1

  for (_, child) in bag.bags.get:
    let res = nYellowBags(child, memo, name)
    if res > 0:
      memo.incl bag.name
      result += res


proc find(bag: Bag; name: string): Bag =
  if bag.name == name: return bag
  if bag.bags.isNone: return nil

  for (_, inner) in bag.bags.get:
    let target = inner.find(name)
    if target != nil:
      return target


proc nBagsRequired(bag: Bag): int =
  if bag.bags.isNone: return 0

  for (n, inner) in bag.bags.get:
    result += n + n * inner.nBagsRequired


proc solve(input: string): int =
  let bags = input.parse

  var bagsWithBags: HashSet[string]
  for bag in bags.values:
    if bag.bags.isSome:
      for (_, child) in bag.bags.get:
        bagsWithBags.incl child.name

  var startingBags: Bags
  for bag in bags.values:
    if bag.name notin bagsWithBags:
      startingBags.add (1, bag)

  var root = Bag(bags: some(startingBags))
  const LookUp = "shiny gold"

  when IsPart1:
    var seen: HashSet[string]
    discard root.nYellowBags(seen, LookUp)
    seen.len - 1
  else:
    let shiny = root.find(LookUp)
    shiny.nBagsRequired


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

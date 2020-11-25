import tables, sequtils, algorithm, strutils, strscans, math, options
import ./core

type
  Name = string
  Happiness = int

  Person = ref object
    name: Name
    happiness: Table[Name, Happiness]

func optimalSeatingArrangement(arrangementPlan: string): Happiness =
  var potentialHappiness: Table[Name, Person]

  for potential in arrangementPlan.splitLines:
    var name, neighbour: Name
    var state: string
    var happiness: Happiness
    discard scanf(potential, "$w would $w $i happiness units by sitting next to $w",
                  name, state, happiness, neighbour)
    if state == "lose": happiness *= -1

    var person = potentialHappiness.mgetOrPut(name, Person(name: name))
    person.happiness[neighbour] = happiness

  var arrangement = toSeq(potentialHappiness.keys)
  when IsPart2:
    arrangement.add("Oktay")

  doWhile arrangement.nextPermutation:
    var sum = 0
    for idx, name in arrangement.pairs:
      when IsPart2:
        if name == "Oktay": continue

      let (left, right) = arrangement.neighbours(idx)
      let person = potentialHappiness[name]
      sum += person.happiness.getOrDefault(left.get) +
             person.happiness.getOrDefault(right.get)

    result = max(result, sum)

when isMainModule:
  echo "Part ", Part, ": ", stdin.readAll.strip.optimalSeatingArrangement

  static:
    when IsPart1:
      const example = """Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol."""
      assert example.optimalSeatingArrangement == 330

import tables
import sequtils
import algorithm
import strutils
import strscans
import math
import ./core

type
  Name = string
  Happiness = int

  Person = ref object
    name: Name
    happiness: Table[Name, Happiness]

proc optimalSeatingArrangement(arrangementPlan: string): Happiness =
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

      let left = arrangement[floorMod((idx - 1), arrangement.len)]
      let right = arrangement[floorMod((idx + 1), arrangement.len)]
      let person = potentialHappiness[name]
      sum += person.happiness.getOrDefault(left) +
             person.happiness.getOrDefault(right)
    if sum > result: result = sum

when isMainModule:
  const input = "Alice would gain 2 happiness units by sitting next to Bob.\nAlice would gain 26 happiness units by sitting next to Carol.\nAlice would lose 82 happiness units by sitting next to David.\nAlice would lose 75 happiness units by sitting next to Eric.\nAlice would gain 42 happiness units by sitting next to Frank.\nAlice would gain 38 happiness units by sitting next to George.\nAlice would gain 39 happiness units by sitting next to Mallory.\nBob would gain 40 happiness units by sitting next to Alice.\nBob would lose 61 happiness units by sitting next to Carol.\nBob would lose 15 happiness units by sitting next to David.\nBob would gain 63 happiness units by sitting next to Eric.\nBob would gain 41 happiness units by sitting next to Frank.\nBob would gain 30 happiness units by sitting next to George.\nBob would gain 87 happiness units by sitting next to Mallory.\nCarol would lose 35 happiness units by sitting next to Alice.\nCarol would lose 99 happiness units by sitting next to Bob.\nCarol would lose 51 happiness units by sitting next to David.\nCarol would gain 95 happiness units by sitting next to Eric.\nCarol would gain 90 happiness units by sitting next to Frank.\nCarol would lose 16 happiness units by sitting next to George.\nCarol would gain 94 happiness units by sitting next to Mallory.\nDavid would gain 36 happiness units by sitting next to Alice.\nDavid would lose 18 happiness units by sitting next to Bob.\nDavid would lose 65 happiness units by sitting next to Carol.\nDavid would lose 18 happiness units by sitting next to Eric.\nDavid would lose 22 happiness units by sitting next to Frank.\nDavid would gain 2 happiness units by sitting next to George.\nDavid would gain 42 happiness units by sitting next to Mallory.\nEric would lose 65 happiness units by sitting next to Alice.\nEric would gain 24 happiness units by sitting next to Bob.\nEric would gain 100 happiness units by sitting next to Carol.\nEric would gain 51 happiness units by sitting next to David.\nEric would gain 21 happiness units by sitting next to Frank.\nEric would gain 55 happiness units by sitting next to George.\nEric would lose 44 happiness units by sitting next to Mallory.\nFrank would lose 48 happiness units by sitting next to Alice.\nFrank would gain 91 happiness units by sitting next to Bob.\nFrank would gain 8 happiness units by sitting next to Carol.\nFrank would lose 66 happiness units by sitting next to David.\nFrank would gain 97 happiness units by sitting next to Eric.\nFrank would lose 9 happiness units by sitting next to George.\nFrank would lose 92 happiness units by sitting next to Mallory.\nGeorge would lose 44 happiness units by sitting next to Alice.\nGeorge would lose 25 happiness units by sitting next to Bob.\nGeorge would gain 17 happiness units by sitting next to Carol.\nGeorge would gain 92 happiness units by sitting next to David.\nGeorge would lose 92 happiness units by sitting next to Eric.\nGeorge would gain 18 happiness units by sitting next to Frank.\nGeorge would gain 97 happiness units by sitting next to Mallory.\nMallory would gain 92 happiness units by sitting next to Alice.\nMallory would lose 96 happiness units by sitting next to Bob.\nMallory would lose 51 happiness units by sitting next to Carol.\nMallory would lose 81 happiness units by sitting next to David.\nMallory would gain 31 happiness units by sitting next to Eric.\nMallory would lose 73 happiness units by sitting next to Frank.\nMallory would lose 89 happiness units by sitting next to George."

  let output = input.optimalSeatingArrangement
  when IsPart1:
    assert output == 733
  else:
    assert output == 725

  echo "Part ", Part, ": ", output

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

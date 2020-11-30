import std/strscans
import ./core

type
  Kilometer = int
  KMs = int
  Second = int

  ReindeerState = enum
    rdFlying, rdResting

  Reindeer = ref object
    name: string
    state: ReindeerState
    speed: KMs
    speedDur: Second
    restDur: Second

    stateT: Second
    travelled: Kilometer

    when IsPart2:
      points: int

const TravelAmount: Second = 2503

proc changeState(reindeer: var Reindeer, state: ReindeerState) =
  reindeer.state = state
  reindeer.stateT = 0

proc travel(reindeer: var Reindeer, distance: Second): Kilometer =
  for _ in 0 ..< distance:
    reindeer.stateT += 1

    case reindeer.state:
    of rdFlying:
      result += reindeer.speed
      if reindeer.stateT == reindeer.speedDur:
        reindeer.changeState(rdResting)
    of rdResting:
      if reindeer.stateT == reindeer.restDur:
        reindeer.changeState(rdFlying)

  reindeer.travelled += result

proc distWinningReindeer(reindeerDesc: string,
                         distance: Second = TravelAmount): Kilometer =
  when IsPart2:
    var reindeers: seq[Reindeer]

  for desc in reindeerDesc.splitlines:
    var name: string
    var speed: KMs
    var speedDur: Second
    var restDur: Second

    discard scanf(desc, "$w can fly $i km/s for $i seconds, but then must rest for $i seconds.$.",
                  name, speed, speedDur, restDur)

    var reindeer = Reindeer(name: move(name), speed: speed,
                            speedDur: speedDur, restDur: restDur, state: rdFlying)

    when IsPart1:
      result = result.max(reindeer.travel(distance))
    else:
      reindeers.add(reindeer)

  when IsPart2:
    var lead = reindeers[0]

    for t in 0 .. distance:
      for rd in reindeers.mitems:
        discard rd.travel(1)
        if rd.travelled > lead.travelled:
          lead = rd
      lead.points += 1

    for rd in reindeers:
      result = result.max(rd.points)

when isMainModule:
  echo fmt"Part {P}: {stdin.readAll.strip.distWinningReindeer}"

  static:
    when IsPart1:
      const exampleDesc = """Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."""
      assert exampleDesc.distWinningReindeer(1000) == 1120

      var comet = Reindeer(name: "Comet", state: rdFlying, speed: 14,
                            speedDur: 10, restDur: 127)
      var dancer = Reindeer(name: "Dancer", state: rdFlying, speed: 16,
                            speedDur: 11, restDur: 162)

      discard comet.travel(1000)
      discard dancer.travel(1000)

      assert comet.travelled == 1120
      assert comet.state == rdResting

      assert dancer.travelled == 1056
      assert dancer.state == rdResting

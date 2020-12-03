type
  SquareKind = enum
    skOpen, skTree

  Map = seq[seq[SquareKind]]

proc parse(s: string): Map =
  for line in s.splitLines:
    var row: seq[SquareKind]
    for c in line:
      case c:
      of '.':
        row.add skOpen
      of '#':
        row.add skTree
      else:
        quit "Invalid square in input"
    result.add move(row)

proc solve(input: string; slope: (int, int)): int =
  let grid = input.parse
  let width = grid[0].len

  var pos = (0, 0)
  while pos[1] < grid.high:
    pos[1] += slope[1]
    pos[0] = (pos[0] + slope[0]) mod width
    if grid[pos[1]][pos[0]] == skTree:
      result += 1

when isMainModule:
  when IsPart1:
    echo OutputPrefix, stdin.readAll.strip.solve (3, 1)
  else:
    import std/[sugar, sequtils, math]
    const slopes = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    let input = stdin.readAll.strip
    echo OutputPrefix, slopes.map(slope => input.solve slope).prod

  static:
    const example = """
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#"""

    assert example.solve((3, 1)) == 7

    when IsPart2:
      assert example.solve((1, 1)) == 2
      assert example.solve((5, 1)) == 3
      assert example.solve((7, 1)) == 4
      assert example.solve((1, 2)) == 2

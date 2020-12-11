iterator adjacent(layout: seq[string]; pos: (int, int)): char =
  const ds = [(-1, -1), (-1, 0), (-1, 1),
              ( 0, -1), #[...]#  ( 0, 1),
              ( 1, -1), ( 1, 0), ( 1, 1)]
  let (px, py) = pos

  when IsPart1:
    for (dx, dy) in ds:
      var x = px + dx
      var y = py + dy
      if y <= layout.high    and y >= layout.low and
         x <= layout[0].high and x >= layout[0].low:
        yield layout[y][x]
  else:
    for (dx, dy) in ds:
      var x = px + dx
      var y = py + dy
      while y <= layout.high    and y >= layout.low and
            x <= layout[0].high and x >= layout[0].low:
        if layout[y][x] != '.':
          yield layout[y][x]
          break
        x += dx
        y += dy


proc step(layout: seq[string]): (int, seq[string]) =
  result[1] = layout
  for y, row in layout.pairs:
    for x, cell in row.pairs:
      block check:
        case cell:
        of '#':
          var count = 0
          for adj in layout.adjacent (x, y):
            if adj == '#':
              count += 1
          if count >= (when IsPart1: 4 else: 5):
            result[1][y][x] = 'L'
            result[0] += 1
        of 'L':
          for adj in layout.adjacent (x, y):
            if adj == '#':
              break check
          result[1][y][x] = '#'
          result[0] += 1
        of '.': discard
        else: assert false


proc solve(input: string): int =
  var layout = input.splitLines
  var changed = 0

  doWhile changed != 0:
    (changed, layout) = layout.step

  for row in layout:
    for cell in row:
      if cell == '#':
        result += 1


when isMainModule:
  echo OutputPrefix, stdin.readAll.strip.solve

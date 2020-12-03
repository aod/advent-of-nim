type
  Vec2*[T] = tuple[x, y: T]

proc `[]`*[T, U, V](xs: array[T, U], p: Vec2[V]): T = xs[p.y][p.x]
proc `[]`*[T, U](xs: seq[seq[T]], p: Vec2[U]): T = xs[p.y][p.x]

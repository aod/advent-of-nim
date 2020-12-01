import os

switch("path", "core")
switch("opt", "speed")
switch("verbosity", "0")
switch("stylecheck", "hint")
switch("import", "core")

let year = projectPath().splitPath.head.splitPath.tail
switch("outDir", "out".joinPath(year))

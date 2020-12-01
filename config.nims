import os

let year = projectPath().splitPath.head.splitPath.tail
switch("outDir", "out/" & year)

import os

let year = projectPath().splitPath.head.splitPath.tail
switch("outDir", "out".joinPath year)

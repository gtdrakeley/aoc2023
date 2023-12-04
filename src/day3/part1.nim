import std/[os, sequtils, sets, strutils, sugar]


let questionRoot = currentSourcePath.parentDir
let inputFilename = "input.txt"
let inputFilepath = questionRoot.joinPath(inputFilename)


type
  SchemaLoc = object
    row, col: int
  SchemaNum = object
    value: string
    loc: SchemaLoc
  SchemaSymbolSet = HashSet[SchemaLoc]
  SchemaNumSeq = seq[SchemaNum]


proc newSchemaLoc(row, col: int): SchemaLoc = SchemaLoc(row: row, col: col)
proc newSchemaNum(value: string, loc: SchemaLoc): SchemaNum = SchemaNum(value: value, loc: loc)


proc getAdjacentLocs(schemaNum: SchemaNum): seq[SchemaLoc] =
  for col in schemaNum.loc.col-1 .. schemaNum.loc.col + schemaNum.value.len:
    result.add newSchemaLoc(schemaNum.loc.row-1, col)
    result.add newSchemaLoc(schemaNum.loc.row+1, col)
  result.add newSchemaLoc(schemaNum.loc.row, schemaNum.loc.col-1)
  result.add newSchemaLoc(schemaNum.loc.row, schemaNum.loc.col+schemaNum.value.len)


proc loadSchemaLine(line: string, rowOffset: int, schemaSymbols: var SchemaSymbolSet, schemaNums: var SchemaNumSeq) =
  var idx = 0
  while idx < line.len:
    if line[idx].isDigit:
      var endIdx = idx
      while endIdx < line.len and line[endIdx].isDigit:
        endIdx += 1
      let value = line[idx ..< endIdx]
      let loc = newSchemaLoc(rowOffset, idx)
      schemaNums.add newSchemaNum(value, loc)
      idx += endIdx - idx
    elif line[idx] != '.':
      schemaSymbols.incl newSchemaLoc(rowOffset, idx)
      idx += 1
    else:
      idx += 1


iterator rowLines(f: File): tuple[row: int, line: string] =
  var row = 0
  for line in f.lines:
    yield (row, line)
    row += 1


proc main =
  let infile = open(inputFilepath, fmRead)
  var schemaSymbols: SchemaSymbolSet
  var schemaNums: SchemaNumSeq
  for row, line in infile.rowLines:
    line.loadSchemaLine(row, schemaSymbols, schemaNums)
  infile.close()
  let partNumbers = collect:
    for num in schemaNums:
      if num.getAdjacentLocs.anyIt(it in schemaSymbols):
        num
  echo partNumbers.mapIt(it.value.parseInt).foldl(a + b)


when isMainModule:
  main()
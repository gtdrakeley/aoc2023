import std/[os, sequtils, strutils]


let questionRoot = currentSourcePath.parentDir
let inputFilename = "input.txt"
let inputFilepath = questionRoot.joinPath(inputFilename)


proc forwardScan(line: string): char =
  for ch in line:
    if ch.isDigit:
      return ch


iterator reverse[T](iter: openArray[T]): T =
  for idx in countup(1, iter.len):
    yield iter[^idx]


proc backwardScan(line: string): char =
  for ch in line.reverse:
    if ch.isDigit:
      return ch


proc intFromLine(line: string): int =
  let firstDigit = forwardScan(line)
  let lastDigit = backwardScan(line)
  parseInt(firstDigit & lastDigit)


proc main =
  let infile = open(inputFilepath, fmRead)
  var nums: seq[int]
  for line in infile.lines:
    nums.add line.intFromLine
  infile.close()
  echo nums.foldl(a + b)


when isMainModule:
  main()

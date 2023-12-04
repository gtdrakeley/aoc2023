import std/[os, sequtils, strutils, sugar, tables]


let questionRoot = currentSourcePath.parentDir
let inputFilename = "input.txt"
let inputFilepath = questionRoot.joinPath(inputFilename)
const intWordCharTable = toOrderedTable(
  {
    "zero": '0',
    "one": '1',
    "two": '2',
    "three": '3',
    "four": '4',
    "five": '5',
    "six": '6',
    "seven": '7',
    "eight": '8',
    "nine": '9'
  }
)


type LocValue = object
  idx: int
  ch: char


proc newLocValue(idx: int, ch: char): LocValue = LocValue(idx: idx, ch: ch)
proc `<`(l, r: LocValue): bool = l.idx < r.idx


proc getFirstDigitCharLoc(line: string): LocValue =
  for idx, ch in line:
    if ch.isDigit:
      return newLocValue(idx, ch)


proc getLastDigitCharLoc(line: string): LocValue =
  for idx in countup(1, line.len):
    if line[^idx].isDigit:
      return newLocValue(line.len - idx, line[^idx])


proc getFirstDigit(line: string): char =
  let firstDigitCharLoc = line.getFirstDigitCharLoc
  let digitWordLocs = collect:
    for word, ch in intWordCharTable.pairs:
      let idx = line.find(word)
      if idx != -1:
        newLocValue(idx, ch)

  min(@[firstDigitCharLoc] & digitWordLocs).ch


proc getLastDigit(line: string): char =
  let lastDigitCharLoc = line.getLastDigitCharLoc
  let digitWordLocs = collect:
    for word, ch in intWordCharTable.pairs:
      let idx = line.rfind(word)
      if idx != -1:
        newLocValue(idx, ch)

  max(@[lastDigitCharLoc] & digitWordLocs).ch


proc getCalibrationValueFromLine(line: string): int = parseInt(getFirstDigit(line) & getLastDigit(line))


proc main =
  let infile = open(inputFilepath, fmRead)
  var nums: seq[int]
  for line in infile.lines:
    nums.add line.getCalibrationValueFromLine
  infile.close()
  echo nums.foldl(a + b)


when isMainModule:
  main()

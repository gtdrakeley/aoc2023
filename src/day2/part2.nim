import std/[os, sequtils, strutils, sugar]


const questionRoot = currentSourcePath.parentDir
const inputFilename = "input.txt"
const inputFilepath = questionRoot.joinPath(inputFilename)


type
  CubeColor = enum
    ccBlue = "blue"
    ccGreen = "green"
    ccRed = "red"
  CubeSet = array[CubeColor, int]
  Game = tuple[id: int, minCubeSet: CubeSet]


proc parseCubeSet(cubeSetStr: string): CubeSet =
  for cubeCountStr in cubeSetStr.split(",").map(s => s.strip):
    let cubeCountSeq = cubeCountStr.split
    result[cubeCountSeq[1].parseEnum[:CubeColor]] = cubeCountSeq[0].parseInt


proc parseCubeSetMany(cubeSetManyStr: string): seq[CubeSet] =
  result = collect:
    for cubeSetStr in cubeSetManyStr.split(";").map(s => s.strip):
      parseCubeSet(cubeSetstr)


proc getMinCubeSet(cubeSetManyStr: string): CubeSet =
  let cubeSets = cubeSetManyStr.parseCubeSetMany
  result = [
    cubeSets.map(cs => cs[ccBlue]).max,
    cubeSets.map(cs => cs[ccGreen]).max,
    cubeSets.map(cs => cs[ccRed]).max
  ]


proc parseGame(gameStr: string): Game =
  let gameSeq = gameStr.split(":").map(s => s.strip)
  let gameId = gameSeq[0]["Game ".len .. high(gameSeq[0])].parseInt
  let minCubeSet = getMinCubeSet(gameSeq[1])
  (id: gameId, minCubeSet: minCubeSet)


proc main =
  let infile = open(inputFilepath, fmRead)
  var gamePowers: seq[int]
  for line in infile.lines:
    let game = line.parseGame
    gamePowers.add game.minCubeSet[ccBlue] * game.minCubeSet[ccGreen] * game.minCubeSet[ccRed]
  infile.close()
  echo gamePowers.foldl(a + b)


when isMainModule:
  main()
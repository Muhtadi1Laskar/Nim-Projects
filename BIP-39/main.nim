import std/[strutils, random]
import ../Common/FileOperations

proc getWordList(): seq[string] = 
    let filePath = "C:/Users/laska/OneDrive/Documents/Coding/Nim/nim-projects/BIP-39/bip39.txt"
    var data: string = FileOperations.read_file(filePath)
    var wordList: seq[string] = data.split("\n")
    return wordList

proc randomByte(len: int): seq[byte] = 
    var randomBytes: array[16, byte]
    randomize()

    for i  in 0 ..< randomBytes.len:
        randomBytes[i] = rand(255).byte

    return @randomBytes

when isMainModule:
    var wordList: seq[string] = getWordList()
    var randomNum: seq[byte] = randomByte(16)

    echo randomNum


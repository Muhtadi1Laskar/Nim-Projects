import std/[strutils]
import ../Common/FileOperations

proc getWordList(): seq[string] = 
    let filePath = "C:/Users/laska/OneDrive/Documents/Coding/Nim/nim-projects/BIP-39/bip39.txt"
    var data: string = FileOperations.read_file(filePath)
    var wordList: seq[string] = data.split("\n")
    return wordList

when isMainModule:
    let filePath = "C:/Users/laska/OneDrive/Documents/Coding/Nim/nim-projects/BIP-39/bip39.txt"
    var data: string = FileOperations.read_file(filePath)

    var wordList: seq[string] = getWordList()

    echo wordList


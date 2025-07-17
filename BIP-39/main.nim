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

proc bitsToChar(b: byte): byte = 
    return byte(ord('0') + int(b and 1))

proc bytesToBits(data: seq[byte]): string = 
    var bits: seq[byte] = @[]

    for b in data:
        bits.add(bitsToChar(b shr 7))
        bits.add(bitsToChar(b shr 6))
        bits.add(bitsToChar(b shr 5))
        bits.add(bitsToChar(b shr 4))
        bits.add(bitsToChar(b shr 3))
        bits.add(bitsToChar(b shr 2))
        bits.add(bitsToChar(b shr 1))
        bits.add(bitsToChar(b))
    return bits.join("")


when isMainModule:
    var wordList: seq[string] = getWordList()
    var entropy: seq[byte] = randomByte(16)

    echo bytesToBits(entropy)


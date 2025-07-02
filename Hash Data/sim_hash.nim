import std/[strutils, sequtils, math]
import nimcrypt

proc hash65(word: string): uint64 = 
    let digest = sha256.digest(word)

    var result: uint64 = 0
    for i in 0 ..< 8:
        result = (result shl 8) or uint64(digest.data[i])
    return result


proc simHash(text: string): uint64 =
  let
    words = text
      .toLowerAscii()
      .replace(re"[^\w\s]", "")
      .splitWhitespace()

  if words.len == 0:
    return 0'u64 

  var vector = newSeq 

  for word in words:
    let h = hash64(word)
      for i in 0 ..< 64:
        if ((h shr i) and 1) == 1:
          vector[i] += 1
        else:
          vector[i] -= 1
        
  var finalHash: uint64 = 0
  for i in 0 ..< 64:
    if vector[i] > 0:
      finalHash = finalHash or (1'u64 shl i)

  return finalHash

when isMainModule:
  let text1 = "Apples are sweet and tasty"
  let text2 = "Apples are tasty and sweet"
  let text3 = "Bananas are yellow and soft"

  echo "Hash 1: ", simHash(text1)
  echo "Hash 2: ", simHash(text2)
  echo "Hash 3: ", simHash(text3)
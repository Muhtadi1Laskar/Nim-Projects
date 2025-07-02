import std/[strutils, sequtils, math, re]
import nimcrypto

proc hash64(word: string): uint64 = 
  let digest = sha256.digest(word)
  var result: uint64

  for i in 0 ..< 8:
    result = (result shl 8) or uint64(digest.data[i])

  return result


when isMainModule:
  let text1 = "The quick brown fox jumped over the lazy dog"
  let text2 = "The quick brown fox jumped over the lazy dog"

  echo ""
  echo "Hash ", hash64(text1)
  echo "Hash ", hash64(text2)
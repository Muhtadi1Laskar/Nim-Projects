import std/[strutils, sequtils, math, re]
import nimcrypto

proc hash64(word: string): uint64 =
    let digest = sha256.digest(word)
    for i in 0 ..< 8:
      result = (result shl 8) or uint64(digest.data[i])

proc sim_hash(text: string): uint64 = 
  let words = text
    .toLowerAscii()
    .replace(re"[^\w\s]", "")
    .splitWhitespace()
    
  if words.len == 0:
    return 0'u64

  var vector = newSeq[int64](64)

  for word in words:
    let h = hash64(word)
    for i in 0 ..< 64:
      vector[i] += ((h shr i) and 1).int * 2 - 1

  for i in 0 ..< 64:
    if vector[i] > 0:
      result = result or (1'u64 shl i)

proc hamming_distance(n: uint64): int =
  result = 0
  var x = n

  while x != 0:
    result += int(x and 1)
    x = x shr 1

when isMainModule:
  let text1 = "Apples are sweet and tasty"
  let text2 = "Apples are tasty and sweet"
  let text3 = "Bananas are yellow and soft"

  let sim_hash1 = sim_hash(text1)
  let sim_hash2 = sim_hash(text2)
  let sim_hash3 = sim_hash(text3)

  echo ""
  echo "Hash ", sim_hash1
  echo "Hash ", sim_hash2
  echo "Hash ", sim_hash3

  echo hamming_distance(sim_hash1 xor sim_hash3)
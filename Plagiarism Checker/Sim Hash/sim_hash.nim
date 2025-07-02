import std/[strutils, sequtils, math, re, bitops]
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

proc hamming_distance(a, b: uint64): int =
  popcount(a xor b)

when isMainModule:
  let
    doc1 = "The quick brown fox jumps over the lazy dog"
    doc2 = "The quick brown fdox leaps overs the lazy dogs"
    doc3 = "Python is a popular programming language"

  let hash1 = sim_hash(doc1)
  let hash2 = sim_hash(doc2)
  let hash3 = sim_hash(doc3)

  echo ""
  echo "Hash ", hash1
  echo "Hash ", hash2
  echo "Hash ", hash3

  echo hamming_distance(hash1, hash2)
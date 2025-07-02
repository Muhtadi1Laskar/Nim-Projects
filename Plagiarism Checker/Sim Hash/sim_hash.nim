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

proc check_plagiarism(doc1, doc2: string): string =
  let hash_one = sim_hash(doc1)
  let hash_two = sim_hash(doc2)
  let score = hamming_distance(hash_one, hash_two)

  if score >= 0 and score <= 3:
    result = "Nearly identical or duplicates. Score: " & $score
  elif score >= 4 and score <= 20:
    result = "Similar topics / paraphrases. Score: " & $score
  elif score >= 11 and score <= 20:
    result = "Some share concepts. Score: " & $score
  elif score >= 21:
    result = "Very different content. Score: " & $score
  else:
    result = "No content"
    
    
when isMainModule:
  let
    doc1 = "The quick fox jumps over the lazy dog"
    doc2 = "The quick dox leaps over the lazy bitch"
    doc3 = "Python is a popular programming language"

  echo ""

  echo check_plagiarism(doc1, doc2)
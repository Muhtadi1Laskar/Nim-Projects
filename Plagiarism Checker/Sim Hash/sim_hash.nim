import std/[strutils, sequtils, math, re]
import nimcrypto

proc hash64(word: string): uint64 = 
  let digest = sha256.digest(word)
  var result: uint64

  for i in 0 ..< 8:
    result = (result shl 8) or uint64(digest.data[i])

  return result

proc sim_hash(text: string): uint64 = 
  let 
    words = text
      .toLowerAscii()
      .replace(re"[^\w\s]", "")
      .splitWhitespace()
    
  if words.len == 0:
    return 0'u64

  var vector = newSeq[int64](64)

  for word in words:
    let h = hash64(word)
    for i in 0 ..< 64:
      if((h shr i) and 1) == 1:
        vector[i] += 1
      else:
        vector[i] = 1
  
  var final_hash: uint64 = 0
  for i in 0 ..< 64:
    if vector[i] > 0:
      final_hash = final_hash or (1'u64 shl i)
  
  return final_hash


when isMainModule:
  let text1 = "The quick brown fox jumped over the lazy dog"
  let text2 = "The quick brown fox jumped over the lazy dog"

  let sim_hash1 = sim_hash(text1)
  let sim_hash2 = sim_hash(text2)

  echo ""
  echo "Hash ", sim_hash1
  echo "Hash ", sim_hash2
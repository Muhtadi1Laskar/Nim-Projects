import std/[strutils, math]

const 
  AlphabetSize: int = 26
  FirstLetter: int = 'a'.ord

type
  AffineKey* = tuple[a, b: int]

proc validateKey*(key: AffineKey): bool =
  gcd(key.a, AlphabetSize) == 1

proc encryptChar*(c: char, key: AffineKey): char =
  if c.isLowerAscii():
    let x: int = c.ord - FirstLetter
    let encrypted: int = (key.a * x + key.b) mod AlphabetSize
    result = chr(encrypted + FirstLetter)
  elif c.isUpperAscii():
    let x: int = c.ord - 'A'.ord
    let encrypted: int = (key.a * x + key.b) mod AlphabetSize
    result = chr(encrypted + 'A'.ord)
  else:
    result = c

proc decryptChar*(c: char, key: AffineKey): char =
  if c.isLowerAscii():
    let y: int = c.ord - FirstLetter
    var a_inv: int = 0
    for i in 1..<AlphabetSize:
      if (key.a * i) mod AlphabetSize == 1:
        a_inv = i
        break
    let decrypted: int = (a_inv * (y - key.b)) mod AlphabetSize
    result = chr(decrypted + FirstLetter)
  elif c.isUpperAscii():
    let y: int = c.ord - 'A'.ord
    var a_inv: int = 0
    for i in 1..<AlphabetSize:
      if (key.a * i) mod AlphabetSize == 1:
        a_inv = i
        break
    let decrypted: int = (a_inv * (y - key.b)) mod AlphabetSize
    result = chr(decrypted + 'A'.ord)
  else:
    result = c

proc encrypt*(text: string, key: AffineKey): string =
  if not validateKey(key):
    raise newException(ValueError, "Invalid key: a must be coprime with 26")
  
  result = newString(text.len)
  for i, c in text:
    result[i] = encryptChar(c, key)

proc decrypt*(text: string, key: AffineKey): string =
  if not validateKey(key):
    raise newException(ValueError, "Invalid key: a must be coprime with 26")
  
  result = newString(text.len)
  for i, c in text:
    result[i] = decryptChar(c, key)

when isMainModule:
  let key: AffineKey = (a: 5, b: 8)
  
  let original: string = "attack at dawn"
  echo "Original: ", original
  
  let encrypted: string = encrypt(original, key)
  echo "Encrypted: ", encrypted
  
  let decrypted: string = decrypt(encrypted, key)
  echo "Decrypted: ", decrypted
  
  let invalidKey: AffineKey = (a: 4, b: 7)
  try:
    discard encrypt("test", invalidKey)
  except ValueError as e:
    echo "Key validation test passed: ", e.msg
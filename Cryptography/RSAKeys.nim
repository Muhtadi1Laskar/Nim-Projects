import std/[strutils, math]

const 
  AlphabetSize = 26
  FirstLetter = 'a'.ord

type
  AffineKey* = tuple[a, b: int]

proc validateKey*(key: AffineKey): bool =
  ## Validate that key.a is coprime with 26
  gcd(key.a, AlphabetSize) == 1

proc encryptChar*(c: char, key: AffineKey): char =
  ## Encrypt a single character using Affine Cipher
  if c.isLowerAscii():
    let x = c.ord - FirstLetter
    let encrypted = (key.a * x + key.b) mod AlphabetSize
    result = chr(encrypted + FirstLetter)
  elif c.isUpperAscii():
    let x = c.ord - 'A'.ord
    let encrypted = (key.a * x + key.b) mod AlphabetSize
    result = chr(encrypted + 'A'.ord)
  else:
    result = c  # Leave non-alphabetic characters unchanged

proc decryptChar*(c: char, key: AffineKey): char =
  ## Decrypt a single character using Affine Cipher
  if c.isLowerAscii():
    let y = c.ord - FirstLetter
    # Find modular multiplicative inverse of a
    var a_inv = 0
    for i in 1..<AlphabetSize:
      if (key.a * i) mod AlphabetSize == 1:
        a_inv = i
        break
    let decrypted = (a_inv * (y - key.b)) mod AlphabetSize
    result = chr(decrypted + FirstLetter)
  elif c.isUpperAscii():
    let y = c.ord - 'A'.ord
    # Find modular multiplicative inverse of a
    var a_inv = 0
    for i in 1..<AlphabetSize:
      if (key.a * i) mod AlphabetSize == 1:
        a_inv = i
        break
    let decrypted = (a_inv * (y - key.b)) mod AlphabetSize
    result = chr(decrypted + 'A'.ord)
  else:
    result = c  # Leave non-alphabetic characters unchanged

proc encrypt*(text: string, key: AffineKey): string =
  ## Encrypt a string using Affine Cipher
  if not validateKey(key):
    raise newException(ValueError, "Invalid key: a must be coprime with 26")
  
  result = newString(text.len)
  for i, c in text:
    result[i] = encryptChar(c, key)

proc decrypt*(text: string, key: AffineKey): string =
  ## Decrypt a string using Affine Cipher
  if not validateKey(key):
    raise newException(ValueError, "Invalid key: a must be coprime with 26")
  
  result = newString(text.len)
  for i, c in text:
    result[i] = decryptChar(c, key)

when isMainModule:
  # Example usage
  let key: AffineKey = (a: 5, b: 8)  # Must satisfy gcd(a, 26) = 1
  
  let original = "attack at dawn"
  echo "Original: ", original
  
  let encrypted = encrypt(original, key)
  echo "Encrypted: ", encrypted
  
  let decrypted = decrypt(encrypted, key)
  echo "Decrypted: ", decrypted
  
  # Test key validation
  let invalidKey: AffineKey = (a: 4, b: 7)  # gcd(4,26) = 2 ≠ 1
  try:
    discard encrypt("test", invalidKey)
  except ValueError as e:
    echo "Key validation test passed: ", e.msg
import std/[strutils, unicode]

proc caesarEncrypt*(text: string, shift: int): string =
  result = newStringOfCap(text.len)
  for c in text:
    if c.isLowerAscii():
      let shifted = ((c.ord - 'a'.ord + shift) mod 26 + 'a'.ord).char
      result.add(shifted)
    elif c.isUpperAscii():
      let shifted = ((c.ord - 'A'.ord + shift) mod 26 + 'A'.ord).char
      result.add(shifted)
    else:
      result.add(c)

proc caesarDecrypt*(text: string, shift: int): string =
  result = newStringOfCap(text.len)
  for c in text:
    if c.isLowerAscii():
      let shifted = ((c.ord - 'a'.ord - shift + 26) mod 26 + 'a'.ord).char
      result.add(shifted)
    elif c.isUpperAscii():
      let shifted = ((c.ord - 'A'.ord - shift + 26) mod 26 + 'A'.ord).char
      result.add(shifted)
    else:
      result.add(c)

when isMainModule:
  let message = "Hello, Nim! 123"
  let shift = 3

  echo "Original: ", message
  let encrypted = caesarEncrypt(message, shift)
  echo "Encrypted: ", encrypted
  let decrypted = caesarDecrypt(encrypted, shift)
  echo "Decrypted: ", decrypted

  echo "\nTesting negative shift (-5):"
  let encrypted2 = caesarEncrypt(message, -5)
  echo "Encrypted: ", encrypted2
  echo "Decrypted: ", caesarDecrypt(encrypted2, -5)
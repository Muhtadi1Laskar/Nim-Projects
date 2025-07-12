import std/[strutils]

proc caesarEncrypt*(text: string, shift: int): string =
  result = newStringOfCap(text.len)
  for c in text:
    if c.isLowerAscii():
      let shifted: char = ((c.ord - 'a'.ord + shift) mod 26 + 'a'.ord).char
      result.add(shifted)
    elif c.isUpperAscii():
      let shifted: char = ((c.ord - 'A'.ord + shift) mod 26 + 'A'.ord).char
      result.add(shifted)
    else:
      result.add(c)

proc caesarDecrypt*(text: string, shift: int): string =
  result = newStringOfCap(text.len)
  for c in text:
    if c.isLowerAscii():
      let shifted: char = ((c.ord - 'a'.ord - shift + 26) mod 26 + 'a'.ord).char
      result.add(shifted)
    elif c.isUpperAscii():
      let shifted: char = ((c.ord - 'A'.ord - shift + 26) mod 26 + 'A'.ord).char
      result.add(shifted)
    else:
      result.add(c)

when isMainModule:
  let message: string = "Hello, Nim! 123"
  let shift: int = 3

  echo "Original: ", message
  let encrypted: string = caesarEncrypt(message, shift)
  echo "Encrypted: ", encrypted
  let decrypted: string = caesarDecrypt(encrypted, shift)
  echo "Decrypted: ", decrypted

  echo "\nTesting negative shift (-5):"
  let encrypted2: string = caesarEncrypt(message, -5)
  echo "Encrypted: ", encrypted2
  echo "Decrypted: ", caesarDecrypt(encrypted2, -5)
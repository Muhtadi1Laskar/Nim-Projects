import std/strutils 

func atbashCipher(input: string): string =
  var encryptedString: string = newStringOfCap(input.len)

  for char in input:
    if char.isAlphaAscii():
      if char.isUpperAscii():
        encryptedString.add(system.char(int('Z') - (int(char) - int('A'))))
      elif char.isLowerAscii():
        encryptedString.add(system.char(int('z') - (int(char) - int('a'))))
    else:
      encryptedString.add(char)
  return encryptedString 

when isMainModule:
  echo "--- Atbash Cipher Examples ---"

  let text1 = "Hello, World!"
  let encrypted1 = atbashCipher(text1)
  echo "Original:  \"" & text1 & "\""
  echo "Encrypted: \"" & encrypted1 & "\""

  let text2 = "ATBASH cipher"
  let encrypted2 = atbashCipher(text2)
  echo "Original:  \"" & text2 & "\""
  echo "Encrypted: \"" & encrypted2 & "\""

  let text3 = "123 ABC xyz!"
  let encrypted3 = atbashCipher(text3)
  echo "Original:  \"" & text3 & "\""
  echo "Encrypted: \"" & encrypted3 & "\""

  let text4 = "abcdefghijklmnopqrstuvwxyz"
  let encrypted4 = atbashCipher(text4)
  echo "Original:  \"" & text4 & "\""
  echo "Encrypted: \"" & encrypted4 & "\""

  let text5 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  let encrypted5 = atbashCipher(text5)
  echo "Original:  \"" & text5 & "\""
  echo "Encrypted: \"" & encrypted5 & "\""
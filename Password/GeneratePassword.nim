import std/[random, strutils]

const 
    UPPER: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    LOWER: string = "abcdefghijklmnopqrstuvwxys"
    DIGITS: string = "0123456789"
    SYMBOLS: string = "!@#$%^&*()-_=+[]{}|;:,.<>?/"


const CHARSET = UPPER & LOWER & DIGITS & SYMBOLS

proc secure_password(length: int): string = 
    if length < 4:
        raise newException(ValueError, "Password length must be at least 4")

    randomize()

    var passwordChars: seq[char] = @[
        UPPER[rand(UPPER.high)],
        LOWER[rand(LOWER.high)],
        DIGITS[rand(DIGITS.high)],
        SYMBOLS[rand(SYMBOLS.high)]
    ]

    for _ in 4 ..< length:
        passwordChars.add(CHARSET[rand(CHARSET.high)])
    
    passwordChars.shuffle()

    return passwordChars.join("")

when isMainModule:
    let password: string = secure_password(10)

    echo password
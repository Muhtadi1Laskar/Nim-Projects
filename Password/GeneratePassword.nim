import std/[random, strutils, tables]

const PASSWORDTYPE: Table[string, string] = {
    "upper": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "lower": "abcdefghijklmnopqrstuvwxyz",
    "digits": "0123456789",
    "symbols": "!@#$%^&*()-_=+[]{}|;:,.<>?/"

}.toTable

proc generate_password(length: int, password_type: seq[string]): string = 
    if length < 4:
        raise newException(ValueError, "Password length must be at least 4")

    randomize()

    for t in password_type:
        let chars: string = PASSWORDTYPE.getOrDefault(t, "")

        result.add(chars[rand(chars.high)])
    
    var char_pool: string
    for t in password_type:
        char_pool.add PASSWORDTYPE[t]
    
    for _ in result.len ..< length:
        result.add(char_pool[rand(char_pool.high)])

    result.shuffle()

    return result.join("")


when isMainModule:
    let password_type: seq[string] = @["upper", "lower", "digits"]
    let password_length: int = 10
    let password: string = generate_password(password_length, password_type)

    echo "\n🔐 Generated Password: ", password
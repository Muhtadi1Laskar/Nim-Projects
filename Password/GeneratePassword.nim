import std/[random, strutils, tables, times, hashes, json]
import nimcrypto

const PASSWORDTYPE: Table[string, string] = {
    "upper": "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "lower": "abcdefghijklmnopqrstuvwxyz",
    "digits": "0123456789",
    "symbols": "!@#$%^&*()-_=+[]{}|;:,.<>?/"
}.toTable

proc generate_salt(length: int): string = 
    var rng: Rand = initRand(cpuTime().hash)
    let chars: string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    for _ in 0 ..< length:
        result.add(chars[rng.rand(chars.len-1)])

proc hash_data(data: string): string = 
    let salt: string = generate_salt(10)
    let combined: string = data & salt
    let hashed_data = toHex(sha256.digest(combined).data, lowercase=true)
    return hashed_data

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

proc write_json(data: Table[string, string]) = 
    let json_table: JsonNode = %*data
    
    writeFile("C:/Users/laska/OneDrive/Documents/Coding/Nim/nim-projects/Password/Saved-Password/password.json", $json_table)


when isMainModule:
    let password_type: seq[string] = @["upper", "lower", "digits"]
    let password_length: int = 10
    let password: string = generate_password(password_length, password_type)
    let hashed_password: string = hash_data(password)
    var data: Table[string, string] = initTable[string, string]()

    data["password"] = password
    data["hashedPassword"] = hashed_password

    echo data

    write_json(data)

    echo "\n🔐 Generated Password: ", password
    echo "\n Password Hash: ", hashed_password
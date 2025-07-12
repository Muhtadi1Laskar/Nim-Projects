import std/[random]


proc generate_random_int(min, max: int): int = 
    return min + rand(max - min)

when isMainModule:
    let num: int = generate_random_int(10, 100)

    echo num
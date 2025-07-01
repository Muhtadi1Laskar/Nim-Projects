import std/[os, streams, strutils, hashes, tables]
import nimcrypto

proc get_files_name(path: string): seq[string] = 
    result = newSeq[string]()

    for kind, file_name in walkDir(path):
        if kind == pcFile:
            result.add(file_name)

proc read_file(path: string): string =
    var result: string
    var f = newFileStream(path, fmRead)

    if f == nil:
        quit("❌ Failed to open file: " & path)

    try: 
        while not f.atEnd():
            result.add(f.readLine() & "\n")
    finally:
        f.close()
            
    return result.strip()

proc hash_data(algorithm: string, data: string): string = 
    case algorithm
    of "sha256":        result = toHex(sha256.digest(data).data, lowercase=true)
    of "sha512":        result = toHex(sha512.digest(data).data, lowercase=true)
    of "sha224":        result = toHex(sha224.digest(data).data, lowercase=true)
    of "sha384":        result = toHex(sha384.digest(data).data, lowercase=true)
    of "sha512_224":    result = toHex(sha512_224.digest(data).data, lowercase=true)
    of "sha512_256":    result = toHex(sha512_256.digest(data).data, lowercase=true)
    else:               result = "Invalid hash algorithm"

when isMainModule:
    let paths: seq[string] = get_files_name("Data")
    let hash_algorithm  = "sha512_256"
    var hash_table: Table[string, string] = initTable[string, string]()

    for path in paths:
        var text = read_file(path)
        hash_table[path] = hash_data(hash_algorithm, text)

    for key, value in hash_table:
        echo key, " ", value

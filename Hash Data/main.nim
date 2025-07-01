import std/[os, streams, strutils, hashes, tables]
import nimcrypto

const ChunkSize = 8192

proc get_files_name(path: string): seq[string] = 
    result = newSeq[string]()

    for kind, file_name in walkDir(path):
        if kind == pcFile:
            result.add(file_name)

proc hash_file(path: string): string =
    var stream = newFileStream(path, fmRead)
    if stream == nil:
        raise newException(IOError, "❌ Failed to open: " & path)

    var ctx: sha512_224
    ctx.init()
    var buffer: array[ChunkSize, byte]

    while not stream.atEnd():
        let read = stream.readData(buffer.addr, ChunkSize)
        if read > 0:
            ctx.update(buffer[0 ..< read])
    stream.close()

    let digest = ctx.finish()
    result = toHex(digest.data, lowercase =  true)

proc read_bytes(path: string): seq[byte] =
    var stream = newFileStream(path, fmRead)
    if stream == nil:
        raise newException(IOError, "❌ Failed to open file: " & path)

    var result: seq[byte] = @[]
    var buffer: array[ChunkSize, byte]

    while not stream.atEnd():
        let read = stream.readData(buffer.addr, buffer.len)
        if read > 0:
            result.add(buffer[0 ..< read])

    stream.close()
    return result

proc hash_bytes(algorithm = "sha256", data: openArray[byte]): string =
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
    let hash_algorithm  = "sha512_224"
    var hash_table: Table[string, string] = initTable[string, string]()

    for path in paths:
        var text = read_bytes(path)
        hash_table[path] = hash_bytes(hash_algorithm, text)

    for key, value in hash_table:
        echo key, " ", value

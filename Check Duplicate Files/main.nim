import os, strutils, tables, hashes
import std/streams
import nimcrypto

const ChunkSize = 8192

proc file_hash(path: string): string = 
    var stream = newFileStream(path, fmRead)
    if stream == nil:
        raise newException(IOError, "❌ Failed to open: " & path)

    var ctx: sha256
    ctx.init()
    var buffer: array[ChunkSize, byte]

    while not stream.atEnd():
        let read = stream.readData(buffer.addr, ChunkSize)
        if read > 0:
            ctx.update(buffer[0 ..< read])
        stream.close()

        let digest = ctx.finish()
        result = toHex(digest.data, lowercase=true)

proc get_all_files(path: string): seq[string] = 
    for kind, f in walkDir(path, relative = false):
        if kind == pcFile:
            result.add(f)

proc find_duplicates(folder: string): Table[string, seq[string]] = 
    let files = get_all_files(folder)
    var hash_map = initTable[string, seq[string]]()

    for file in files:
        try:
            let hash = file_hash(file)
            hash_map.mgetOrPut(hash, @[]).add(file)
        except IOError:
            echo "⚠️ Skipping unreadable file: ", file
    
    for k, v in hash_map.pairs:
        if v.len > 1:
            result[k] = v
            
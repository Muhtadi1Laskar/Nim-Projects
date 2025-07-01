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
        
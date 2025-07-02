import std/[os, streams, strutils, sequtils]

proc read_file*(path: string): string = 
    var result: string
    let f = newFileStream(path, fmRead)
    if f == nil:
        raise newException(IOError, "❌ Failed to open: " & path)

    try:
        while not f.atEnd():
            result.add(f.readLine() & "\n")
    finally:
        f.close()
    
    return result.strip()

proc read_bytes*(path: string): seq[byte] = 
    const ChunkSize = 8192
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

proc get_all_files*(path: string): seq[string] = 
    for kind, f in walkDir(path, relative = true):
        if kind == pcFile:
            result.add("Data\\" & f)
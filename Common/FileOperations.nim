import std/[os, streams, strutils, sequtils, times]

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

proc get_all_files*(path: string, types: bool = false): seq[string] = 
    for kind, f in walkDir(path, relative = types):
        if kind == pcFile:
            result.add(f)

proc get_date_time*(): string = 
    let date_time = now().utc
    return $date_time
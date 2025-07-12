import std/[os, streams, strutils, times]

proc read_file*(path: string): string = 
    let f: FileStream = newFileStream(path, fmRead)
    if f == nil:
        raise newException(IOError, "❌ Failed to open: " & path)

    try:
        while not f.atEnd():
            result.add(f.readLine() & "\n")
    finally:
        f.close()
    
    return result.strip()

proc read_bytes*(path: string): seq[byte] = 
    const ChunkSize: int = 8192
    var stream: FileStream = newFileStream(path, fmRead)
    if stream == nil:
        raise newException(IOError, "❌ Failed to open file: " & path)

    var buffer: array[ChunkSize, byte]

    while not stream.atEnd():
        let read: int = stream.readData(buffer.addr, buffer.len)
        if read > 0:
            result.add(buffer[0 ..< read])
    stream.close()

    return result

proc get_all_files*(path: string, types: bool = false): seq[string] = 
    for kind, f in walkDir(path, relative = types):
        if kind == pcFile:
            result.add(f)

proc get_date_time*(): string = 
    let date_time: DateTime = now().utc
    return $date_time
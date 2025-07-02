import std/[os, streams, strutils, sequtils,]

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
        
import tables
import std/streams
import nimcrypto
import ../Common/FileOperations

const ChunkSize: int = 8192

proc file_hash(path: string): string = 
    var stream: FileStream = newFileStream(path, fmRead)
    if stream == nil:
        raise newException(IOError, "❌ Failed to open: " & path)

    var ctx: sha256
    ctx.init()
    var buffer: array[ChunkSize, byte]

    while not stream.atEnd():
        let read: int = stream.readData(buffer.addr, ChunkSize)
        if read > 0:
            ctx.update(buffer[0 ..< read])
    stream.close()

    let digest = ctx.finish()
    result = toHex(digest.data, lowercase=true)

proc find_duplicates(folder: string): Table[string, seq[string]] = 
    let files: seq[string] = FileOperations.get_all_files(folder)
    var hash_map: Table[system.string, seq[string]] = initTable[string, seq[string]]()

    for file in files:
        try:
            let hash: string = file_hash(file)
            hash_map.mgetOrPut(hash, @[]).add(file)
        except IOError:
            echo "⚠️ Skipping unreadable file: ", file
    
    for k, v in hash_map.pairs:
        if v.len > 1:
            result[k] = v

when isMainModule:
    let targetDir: string = "Data"  # 🔁 Replace with your directory
    let duplicates: Table[system.string, seq[string]] = find_duplicates(targetDir)

    if duplicates.len == 0:
        echo "✅ No duplicate files found!"
    else:
        echo "🗂️ Duplicate Files Found:"
    for k, files in duplicates.pairs:
        echo "\n🔑 Hash: ", k
        for f in files:
            echo "  - ", f
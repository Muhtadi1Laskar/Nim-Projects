import  std/[os, streams, strutils, json, jsonutils, tables, times]
import nimcrypto
import ../Common/FileOperations

const ChunkSize = 8192

proc load_data(path: string): Table[string, string] = 
    let json_data = FileOperations.read_file(path)
    let node = parseJson(json_data)

    if node.len == 0:
        echo "The file is empty"
        return

    var t: Table[string, string]
    for k, v in node.pairs:
        t[k] = v.getStr()
    
    return t

proc hash_data(path: string): string = 
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
    result = toHex(digest.data, lowercase = true)

when isMainModule:
    let files_path = FileOperations.get_all_files("./Data")
    var file_array: seq[Table[string, string]]

    for path in files_path:
        var file_hash_table = initTable[string, string]()
        var hash = hash_data(path)

        if not file_hash_table.hasKey(path):
            file_hash_table["name"] = path
            file_hash_table["hash"] = hash
            file_hash_table["createdAt"] = FileOperations.get_date_time()
        
        file_array.add(file_hash_table)
    
    # for k, v in file_hash_table.pairs:
    #     echo k, v

    echo file_array[7]

    # for i in file_array:
    #     echo i


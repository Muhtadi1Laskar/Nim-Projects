import  std/[os, streams, strutils, json, jsonutils, tables, times, sets]
import nimcrypto
import ../Common/FileOperations

const ChunkSize = 8192

proc load_data(path: string): seq[Table[string, string]] = 
    var result: seq[Table[string, string]]
    let json_data = FileOperations.read_file(path)
    let node = parseJson(json_data)

    if node.len == 0:
        echo "The file is empty"
        return

    for item in node:
        var t: Table[string, string]
        for k, v in item.pairs:
            t[k] = v.getStr()
        result.add(t)                      
    
    return result

proc write_json(data: seq[Table[string, string]]) = 
    let json_table = %*data
    
    writeFile("./JsonData/hashes.json", $json_table)

proc hash_data(path: string): string = 
    var stream = newFileStream(path, fmRead)
    if stream == nil:
        raise newException(IOError, "❌ Failed to open: " & path)

    var ctx: keccak256
    ctx.init()
    var buffer: array[ChunkSize, byte]

    while not stream.atEnd():
        let read = stream.readData(buffer.addr, ChunkSize)
        if read > 0:
            ctx.update(buffer[0 ..< read])
    stream.close()

    let digest = ctx.finish()
    result = toHex(digest.data, lowercase = true)

proc hash_files(path: string): seq[Table[string, string]] = 
    var files_path= FileOperations.get_all_files(path, true)
    var file_array: seq[Table[string, string]]

    for idx, path in files_path:
        var file_hash_table = initTable[string, string]()
        var hash = hash_data("./Data/" & path)

        if not file_hash_table.hasKey(path):
            file_hash_table["name"] = path
            file_hash_table["hash"] = hash
            file_hash_table["createdAt"] = FileOperations.get_date_time()
        
        file_array.add(file_hash_table)
    
    return file_array

proc save_hash_files(path: string) = 
    let hashed_data = hash_files(path)
    write_json(hashed_data)

proc findAlteredHashes(data_one, data_two: openArray[Table[string, string]]): seq[string] =
    var
        hashes_one = initTable[string, string]()
        hashes_two = initTable[string, string]()
    
    for item in data_one:
        hashes_one[item.getOrDefault("name")] = item.getOrDefault("hash")
    
    for item in data_two:
        hashes_two[item.getOrDefault("name")] = item.getOrDefault("hash")
    
    for name, hash1 in hashes_one.pairs:
        let hash2 = hashes_two.getOrDefault(name, "")
        if hash1 != hash2:
            result.add(name)
    
proc get_keys(hash_tables: seq[Table[string, string]]): seq[string] = 
    for item in hash_tables:
        result.add(item.getOrDefault("name"))
    return result

proc check_hash(): string = 
    let saved_file_path = "./JsonData/hashes.json"
    let data_file_path = "./Data"

    let saved_files: seq[Table[string, string]] = load_data(saved_file_path)
    if saved_files.len == 0:
        return "There is no saved files"

    let current_files: seq[Table[string, string]] = hash_files(data_file_path)
    if current_files.len == 0:
        return "These is no data file"

    var saved_hash_files: seq[string] = get_keys(saved_files)
    var current_hash_files: seq[string] = get_keys(current_files)

    let altered_files: seq[string] = findAlteredHashes(saved_files, current_files)
    let missing_files = toHashSet(saved_hash_files) - toHashSet(current_hash_files)
    let new_files = toHashSet(current_hash_files) - toHashSet(saved_hash_files)

    if altered_files.len == 0 and missing_files.len == 0 and new_files.len == 0:
        return "✅ All files are consistent"

    if altered_files.len > 0:
        echo "Altered Files: ", altered_files
    if missing_files.len > 0:
        echo "Missing Files: ", missing_files
    if new_files.len > 0:
        echo "New Files: ", new_files

    return "🔍 Hash check completed"
  

when isMainModule:
    let file_path = "./Data"

    # save_hash_files(file_path)
    let s = check_hash()

    echo s


import  std/[os, streams, strutils, json, jsonutils, tables]
import ../Common/FileOperations

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

proc 


when isMainModule:
    let data = load_data("./JsonData/hashes.json")
    
    echo data.len


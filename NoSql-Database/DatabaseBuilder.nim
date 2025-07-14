import std/[os]

proc createCollection*(path: string): bool = 
    if not dirExists(path):
        createDir(path)
        echo "Successfully create the Collection"
        return true
    echo "Failed to create the Collection"
    return false

proc createDocument*(path: string) = 
    writeFile(path, """{}""")
    echo "Successfully created the Document"


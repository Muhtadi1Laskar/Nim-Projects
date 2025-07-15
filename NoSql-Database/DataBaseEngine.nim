import DataBaseBuilder

when isMainModule:
    let path: string = "./Database/Patients"

    discard DataBaseBuilder.createCollection(path)
    DataBaseBuilder.createDocument(path & "/users.json")
    
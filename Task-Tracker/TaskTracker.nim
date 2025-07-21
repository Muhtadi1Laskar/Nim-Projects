import std/[os, strformat, strutils, json]
import ../Common/FileOperations

type
    Task = ref object
        id: int
        description: string
        status: string
        createdAt: string
        updatedAt: string
        next: Task

type
    TaskTracker = ref object
        head: Task
        length: int

proc newTracker(): TaskTracker =
    return TaskTracker(head: nil, length: 0)
 
proc append(list: TaskTracker, value: Task) = 
    var newNode: Task = Task(value)

    if list.head.isNil:
        list.head = newNode
    else:
        var currentNode: Task = list.head
        while not currentNode.next.isNil:
            currentNode = currentNode.next

        currentNode.next = newNode

    list.length += 1
    return 

proc add(list: TaskTracker, value: string) = 
    var task: Task = Task(
        id: list.length + 1,
        description: value,
        status: "todo",
        createdAt: FileOperations.get_date_time(),
        updatedAt: ""
    )
    list.append(task)
    return 

proc updateID(list: TaskTracker) = 
    var currentNode: Task = list.head
    var index: int = 1

    while not currentNode.isNil and index <= list.length:
        currentNode.id = index
        currentNode = currentNode.next
        index += 1

proc delete(list: TaskTracker, id: int) = 
    if id < 1 or id > list.length:
        echo "There is no task associated with the given id \n"
        return
    if list.head.isNil:
        echo "There is no task"
        return

    if id == 1:
        list.head = list.head.next
        list.length -= 1
        list.updateID()
        return

    var prevNode: Task = list.head

    for i in 2..<id:
        prevNode = prevNode.next
    
    var nodeToDelete: Task = prevNode.next
    prevNode.next = nodeToDelete.next

    if id != list.length:
        list.updateID()

    list.length -= 1
    return

proc update(list: TaskTracker, id: int, fieldToUpdate, value: string) = 
    if list.head.isNil:
        echo "There is no tasks"
        return
    
    if id < 1 or id > list.length:
        echo "There is no task accociated with the given id \n"
        return

    var nodeToUpdate: Task = list.head
    for i in 1..<id:
        nodeToUpdate = nodeToUpdate.next
    
    if fieldToUpdate == "description":
        nodeToUpdate.description = value
    elif fieldToUpdate == "status":
        nodeToUpdate.status = value
    else:
        echo "Invalid field"
        return

proc printAllTasks(list: TaskTracker) =
  if list.head.isNil:
    echo "There are no tasks"
    return

  var currentNode: Task = list.head
  while not currentNode.isNil:
    echo fmt"""
Task No.    : {currentNode.id}
Description: {currentNode.description}
Status     : {currentNode.status}
CreatedAt  : {currentNode.createdAt}
UpdatedAt  : {currentNode.updatedAt}
"""
    currentNode = currentNode.next

proc printTaskByFilter(list: TaskTracker, filter: string) = 
    if list.head.isNil:
        echo "There are no tasks"
        return
    
    var currentNode: Task = list.head
    while not currentNode.isNil:
        if currentNode.status == filter:
            echo "\nTask No. :", currentNode.id
            echo "Description: ", currentNode.description
            echo "Status: ", currentNode.status
            echo "CreatedAt: ", currentNode.createdAt
            echo "UpdatedAt: ", currentNode.updatedAt
            echo ""
        currentNode = currentNode.next

proc save(list: TaskTracker) = 
    var nodes: JsonNode = newJArray()
    var currentNode: Task = list.head

    while not currentNode.isNil:
        let taskNode = %*{
            "id": currentNode.id,
            "description": currentNode.description,
            "status": currentNode.status,
            "createdAt": currentNode.createdAt,
            "updatedAt": currentNode.updatedAt
        }
        nodes.add(taskNode)
        currentNode = currentNode.next

    writeFile("./Data/tasks.json", $nodes)

proc load(list: TaskTracker) = 
    let jsonData: string = FileOperations.read_file("./Data/tasks.json")
    let nodes: JsonNode = parseJson(jsonData)

    if nodes.len == 0:
        return

    for node in nodes:
        var task: Task = Task(
            id: node["id"].getInt,
            description: node["description"].getStr,
            status: node["status"].getStr,
            createdAt: node["createdAt"].getStr,
            updatedAt: node["updatedAt"].getStr,
        )
        list.append(task)
    

when isMainModule:
    var tracker: TaskTracker = newTracker()
    tracker.load()

    let
        args: seq[string] = commandLineParams()
    
    if paramCount() == 0:
        echo "Usage: task-cli [command] [arguments]"
        echo "\nCommands:"
        echo "  add <description>       Add new task"
        echo "  update <id> <desc>     Update task description"
        echo "  delete <id>            Delete task"
        echo "  mark-done <id>         Mark task as done"
        echo "  mark-progress <id>     Mark task as in-progress"
        echo "  list [status]          List all tasks or filter by status"
        quit(1)
    
    let command: string = paramStr(1)

    case command
    of "add":
        if paramCount() < 2:
            echo "Error: Task description is required"
            quit(1)
        let description: string = paramStr(2)
        tracker.add(description)
        tracker.save()
        echo "Task added successfully (ID: ", tracker.length, ")"

    of "update":
        if paramCount() < 3:
            echo "Error: update requires id and new description"
            quit(1)
        let id: int = parseInt(paramStr(2))
        let desc: string = paramStr(3)
        tracker.update(id, "description", desc)
        tracker.save()
        echo "Task updated (ID: ", id, ")"
    
    of "delete":
        let id: int = parseInt(paramStr(2))
        tracker.delete(id)
        tracker.save()
        echo "Deleted task ID: ", id

    of "mark-done", "mark-in-progress":
        let id: int = parseInt(paramStr(2))
        let newStatus: string = if command == "mark-done": "done" else: "in-progress"
        tracker.update(id, "status", newStatus)
        tracker.save()
        echo "Task ", id, " marked as ", newStatus

    of "list":
        if paramCount() == 2:
            tracker.printTaskByFilter(paramStr(2))
        else:
            tracker.printAllTasks()

    else:
        echo "Unknown command: ", command

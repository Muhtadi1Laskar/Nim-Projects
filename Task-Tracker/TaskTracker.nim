import strformat
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

proc append(list: TaskTracker, value: string) = 
    list.length += 1

    var newNode: Task = Task(
        id: list.length,
        description: value,
        status: "todo",
        createdAt: FileOperations.get_date_time(),
        updatedAt: ""
    )

    if list.head.isNil:
        list.head = newNode
        return

    var currentNode: Task = list.head

    while not currentNode.next.isNil:
        currentNode = currentNode.next

    currentNode.next = newNode

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
    echo "There is no task"
    return

  var currentNode = list.head
  while not currentNode.isNil:
    echo fmt"""
Task No.    : {currentNode.id}
Description: {currentNode.description}
Status     : {currentNode.status}
CreatedAt  : {currentNode.createdAt}
UpdatedAt  : {currentNode.updatedAt}
"""
    currentNode = currentNode.next
    

when isMainModule:
    var tracker: TaskTracker = newTracker()

    tracker.append("Read book")
    tracker.append("Buy Groceries")
    tracker.append("Cook dinner")
    tracker.append("Clean the coffee machine")
    tracker.append("Take notes on system design interview")
    tracker.append("Watch the anime Sakamoto Days")

    # tracker.printAllTask()

    tracker.delete(7)

    echo "Updated List: \n"

    tracker.printAllTasks()

    tracker.update(2, "status", "in progress")
    tracker.update(4, "status", "done")

    tracker.printAllTasks()
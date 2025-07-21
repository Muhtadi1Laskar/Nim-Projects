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
    if list.head.isNil:
        echo "There is no task"
        return

    if id == 1:
        list.head = list.head.next
        list.length -= 1
        list.updateID()
        return

    var prevNode: Task = list.head

    for i in 1..<id-1:
        prevNode = prevNode.next
    
    var nodeToDelete: Task = prevNode.next
    prevNode.next = nodeToDelete.next

    if id != list.length:
        list.updateID()

    list.length -= 1
    return



proc printAllTask(list: TaskTracker) = 
    if list.head.isNil:
        echo "There is no task"
        return

    var currentNode: Task = list.head

    while not currentNode.isNil:
        echo "\nTask No. :", currentNode.id
        echo "Description: ", currentNode.description
        echo "Status: ", currentNode.status
        echo "CreatedAt: ", currentNode.createdAt
        echo "UpdatedAt: ", currentNode.updatedAt
        echo ""

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

    tracker.delete(1)

    echo "Updated List: \n"

    tracker.printAllTask()
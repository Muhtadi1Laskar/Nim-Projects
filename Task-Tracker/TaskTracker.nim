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

    tracker.printAllTask()
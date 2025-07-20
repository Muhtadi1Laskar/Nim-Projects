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


when isMainModule:
    var tracker: TaskTracker = newTracker()    
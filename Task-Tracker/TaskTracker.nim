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


when isMainModule:
    var tracker: TaskTracker = newTracker()    
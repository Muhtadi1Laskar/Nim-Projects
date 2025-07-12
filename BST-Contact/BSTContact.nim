import std/[tables, sequtils]

type
    Contact = ref object
        name: string
        number: string

type 
    Node[T] = ref object
        left: Node[T]
        right: Node[T]
        value: T

type 
    Tree[T] = ref object
        root: Node[T]

proc new_tree[T](): Tree[T] = 
    return Tree[T](root: nil)

proc insert_helper[T](self: Tree[T], node: Node[T], value: T) =
    if node.value.name > value.name:
        if node.left.isNil:
            node.left = Node[T](value: value)
        else:
            self.insert_helper(node.left, value)
    else:
        if node.right.isNil:
            node.right = Node[T](value: value)
        else:
            self.insert_helper(node.right, value)
    
proc insert[T](self: Tree[T], value: T) = 
    if self.root.isNil:
        self.root = Node[T](value: value)
    else:
        self.insert_helper(self.root, value)

proc search[T](self: Tree[T], value: T): Table[string, string] = 
    var current_node = self.root
    result = initTable[string, string]()

    while not current_node.isNil:
        if value.name < current_node.value.name:
            current_node = current_node.left
        elif value.name > current_node.value.name:
            current_node = current_node.right
        else:
            result[current_node.value.name] = current_node.value.number 
            return result

proc update[T](self: Tree[T], name: string, number: string) = 
    var current_node: Node[BSTContact.Contact] = self.root
    while not current_node.isNil:
        if name == current_node.value.name:
            current_node.value.number = number
            return
        elif name < current_node.value.name:
            current_node = current_node.left
        else:
            current_node = current_node.right
    echo name & " is not available in the contact\n"

proc traversal[T](self: Tree[T]) = 
    proc walk(node: Node[T]) = 
        if not node.isNil:
            walk(node.left)
            echo $node.value.name & " " & $node.value.number
            walk(node.right)
    walk(self.root)

proc breadth_first_search[T](self: Tree[T]): seq[T] = 
    if self.root.isNil:
        echo "The tree is empty"
        return @[]
    var list: seq[T] = @[]
    var queue: seq[Node[T]] = @[self.root]

    while queue.len > 0:
        var current_node: Node[BSTContact.Contact] = queue[0]
        queue = queue[1 ..< queue.len]
        list.add(current_node.value)

        if not current_node.left.isNil:
            queue.add(current_node.left)
        if not current_node.right.isNil:
            queue.add(current_node.right)
    return list

when isMainModule:
    let bst: Tree[BSTContact.Contact] = new_tree[Contact]()

    bst.insert(Contact(name: "Luffy", number: "01775900737"))
    bst.insert(Contact(name: "Zoro", number: "01866758443"))
    bst.insert(Contact(name: "Name", number: "01775900737"))
    bst.insert(Contact(name: "Sanji", number: "01775900737"))
    bst.insert(Contact(name: "Usopp", number: "01775900737"))
    bst.insert(Contact(name: "Chopper", number: "01775900737"))
    bst.insert(Contact(name: "Robin", number: "01775900737"))
    bst.insert(Contact(name: "Franky", number: "01775900737"))
    bst.insert(Contact(name: "Babel", number: "01775900737"))

    bst.traversal()

    echo " "
    echo bst.search(Contact(name: "Franky")), "\n"

    echo bst.breadth_first_search().mapIt((it.name, it.number)), "\n"

    bst.update("Zorso", "999222333")

    bst.traversal()
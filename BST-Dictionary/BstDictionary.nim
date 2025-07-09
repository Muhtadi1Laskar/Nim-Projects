import std/[tables]

type
    Contact = ref object
        name: string
        number: int

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

proc search[T](self: Tree[T], value: T): Table[string, int] = 
    var result: Table[string, int] = initTable[string, int]()
    var current_node = self.root

    while not current_node.isNil:
        if current_node.value.name > value.name:
            current_node = current_node.left
        elif current_node.value.name < value.name:
            current_node = current_node.right
        else:
            result[current_node.value.name] = current_node.value.number
            return result
        

proc traversal[T](self: Tree[T], node: Node[T] = self.root) = 
    if not node.isNil:
        self.traversal(node.left)
        echo $node.value.name & " " & $node.value.number
        self.traversal(node.right)

when isMainModule:
    let bst = new_tree[Contact]()

    bst.insert(Contact(name: "Luffy", number: 01775900737))
    bst.insert(Contact(name: "Zoro", number: 01866758443))
    bst.insert(Contact(name: "Name", number: 01775900737))
    bst.insert(Contact(name: "Sanji", number: 01775900737))
    bst.insert(Contact(name: "Usopp", number: 01775900737))
    bst.insert(Contact(name: "Chopper", number: 01775900737))
    bst.insert(Contact(name: "Robin", number: 01775900737))
    bst.insert(Contact(name: "Franky", number: 01775900737))

    bst.traversal(bst.root)

    echo " "
    echo bst.search(Contact(name: "Franky"))
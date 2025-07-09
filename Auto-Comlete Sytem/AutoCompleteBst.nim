type
    Node = ref object
        left: Node
        right: Node
        value: string

type 
    Tree = ref object
        root: Node

proc new_tree(): Tree = 
    return Tree(root: nil)

proc insert_helper(bst: Tree, value: string) =
    if bst.value < value:
        if node.left.isNil:
            node.left = Node(value: value)
        else:
            bst.insert_helper(node.left, value)
    else:
        if node.right.isNil:
            node.right = Node(value: value)
        else: 
            bst.insert_helper(node.right, value)
    

proc insert(bst: Tree, value: string) = 
    if bst.root.isNil:
        bst.root = Node(value: value)
        return
    else:
        bst.insert_helper(bst.root, value)

when isMainModule:
    let tree = new_tree()


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


when isMainModule:
    let tree = new_tree()

    
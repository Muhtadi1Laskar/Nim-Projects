import std/[strutils]

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

proc insert_helper(bst: Tree, node: Node, value: string) =
    if node.value > value:
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


proc auto_complete(bst: Tree, prefix: string): seq[string] = 
    var result: seq[string] = @[]
    proc traverse(n: Node) = 
        if n.isNil:
            return

        if n.value.startsWith(prefix):
            traverse(n.left)
            result.add(n.value)
            traverse(n.right)
        elif n.value < prefix:
            traverse(n.right)
        else:
            traverse(n.left)
            
    traverse(bst.root)
    return result

proc in_order_traversal(bst: Tree) = 
    proc walk(node: Node) = 
        if not node.isNil:
            walk(node.left)
            echo node.value
            walk(node.right)
    walk(bst.root)

proc depth_first_search(bst: Tree): seq[string] = 
    var result: seq[string] = @[]
    var stack: seq[Node] = @[]
    var current = bst.root

    while not current.isNil or stack.len > 0:
        while not current.isNil:
            stack.add(current)
            current = current.left

        current = stack.pop()
        result.add(current.value)

        current = current.right

    return result


when isMainModule:
    let tree = new_tree()

    for word in ["apple", "app", "apricot", "banana", "ball", "cat", "a", "czech", "carrot"]:
        tree.insert(word)

    echo "Autocomplete for 'ab': ", tree.auto_complete("apple")
    echo "Autocomplete for 'ba': ", tree.auto_complete("ba")
    echo "Autocomplete for 'c': ", tree.auto_complete("c")

    tree.in_order_traversal()



    
    echo tree.depth_first_search()


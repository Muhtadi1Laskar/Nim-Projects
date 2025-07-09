import std/[strutils]
import ../Common/FileOperations

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


when isMainModule:
    let tree = new_tree()

    for word in ["apple", "app", "apricot", "banana", "ball", "cat", "czech", "carrot"]:
        tree.insert(word)

    echo "Autocomplete for 'ab': ", tree.auto_complete("apple")
    echo "Autocomplete for 'ba': ", tree.auto_complete("ba")
    echo "Autocomplete for 'c': ", tree.auto_complete("c")


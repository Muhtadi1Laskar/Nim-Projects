import std/[os, streams, strutils, sequtils, math, re, bitops]
import ../../Common/FileOperations

when isMainModule:
    let data = FileOperations.read_file("../Data/test1.txt")

    echo data
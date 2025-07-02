import std/[os, streams, strutils, sequtils, math, re, bitops, tables]
import ../../Common/FileOperations

proc tokenize(data: string): seq[string] = 
    result = data.toLowerAscii().replace(re"[^\w\s]", "").splitWhitespace()

proc remove_stopwords(data_seq: seq[string]): seq[string] = 
    var result: seq[string] = @[]
    let stop_words = {
        "a": "", "an": "", "this": "", "the": "", "is": "", "are": "", "was": "", "were": "", "will": "", "be": "",
        "in": "", "on": "", "at": "", "of": "", "for": "", "to": "", "from": "", "with": "",
        "and": "", "or": "", "but": "", "not": "", "if": "", "then": "", "else": "",
        "i": "", "you": "", "he": "", "she": "", "it": "", "we": "", "they": "", "my": "", "your": "", "his": "", "her": "", "its": "", "our": "", "their": "",
        "while": "", "that": "", "shes": "", "hes": "", "theirs": ""
    }.toTable

    for ch in data_seq:
        if not stop_words.hasKey(ch):
            result.add(ch)

    return result



when isMainModule:
    let data = FileOperations.read_file("../Data/test1.txt")
    let tokenized = tokenize(data)

    echo remove_stopwords(tokenized).len
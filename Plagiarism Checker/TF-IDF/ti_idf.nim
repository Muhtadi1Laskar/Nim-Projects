import std/[os, streams, strutils, sequtils, math, re, bitops, tables]
import ../../Common/FileOperations

proc tokenize(data: string): seq[string] = 
    result = data.toLowerAscii().replace(re"[^\w\s]", "").splitWhitespace()

proc count_frequency(data:seq[string]): Table[string, int] = 
    var result = initTable[string, int]()

    for ch in data:
        if not result.hasKey(ch):
            result[ch] = 1
        else:
            result[ch] += 1
    
    return result

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
    let clean_text = remove_stopwords(tokenized)

    echo count_frequency(clean_text)
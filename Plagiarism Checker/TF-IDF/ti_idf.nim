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

proc calculate_tf(words: seq[string]): Table[string, float] = 
    var tf = initTable[string, float64]()
    var total_words = float(len(words))

    for word in words:
        if not tf.hasKey(word):
            tf[word] = 1
        else:
            tf[word] += 1
    
    for key, value in tf:
        tf[key] /= total_words
    
    return tf

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
    let clean_text = remove_stopwords(tokenize(data))
    var corpuse: seq[seq[string]] = @[clean_text]

    # echo count_frequency(clean_text)
    var tf = calculate_tf(clean_text)

    echo tf["gatsby"] 
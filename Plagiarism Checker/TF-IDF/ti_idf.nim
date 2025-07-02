import std/[os, streams, strutils, sequtils, math, re, bitops, tables, sets]
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
    var total_words = words.len.float

    for word in words:
        tf.mgetOrPut(word, 0) += 1

    for key, value in tf:
        tf[key] /= total_words
    
    return tf

proc calculate_IDF(corpus: seq[seq[string]]): Table[string, float] = 
    var df_table = initTable[string, int]()
    let total_docs = corpus.len.float
  
    for document in corpus:
        var unique_words = toHashSet(document)
    
        for word in unique_words:
            df_table.mgetOrPut(word, 0) += 1
  
    result = initTable[string, float]()
    for word, df_count in df_table.pairs:
        result[word] = ln(total_docs / (1 + df_count.float))


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
    var corpus: seq[seq[string]] = @[clean_text]

    # echo count_frequency(clean_text)
    var tf = calculate_tf(clean_text)
    var idf = calculate_IDF(corpus)

    echo tf
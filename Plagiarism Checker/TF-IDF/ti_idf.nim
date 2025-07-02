import std/[os, streams, strutils, sequtils, math, re, bitops, tables, sets]
import ../../Common/FileOperations

const stop_words = toHashSet([
        "a", "an", "this", "the", "is", "are", "was", "were", "will", "be",
        "in", "on", "at", "of", "for", "to", "from", "with",
        "and", "or", "but", "not", "if", "then", "else",
        "i", "you", "he", "she", "it", "we", "they", "my", "your", "his", "her",
         "its", "our", "their",
        "while", "that", "shes", "hes", "theirs", "didn't", "couldn't", "wasn't", "don't",
        "weren't", "hadn't", "i'm", 
        "you're", "what's", "you'd", "your's", "that's", "she'd", "i've", 
    ])

proc tokenize(data: string): seq[string] = 
    let cleaned = data
                  .toLowerAscii()
                  .replace(re"[-]{2,}", " ")  
    let tokenPattern = re"\b[\w'-]+\b"  

    result = newSeq[string]()
    for m in findAll(cleaned, tokenPattern):
        if m != "-" and m != "'":
            result.add(m)

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

proc normalize_word(word: string): string =
  result = word.toLowerAscii().strip(chars={'.', ',', '!', '?', ';', ':', '"', '\''})

proc remove_stopwords(data_seq: seq[string]): seq[string] = 
    var result: seq[string] = @[]

    for word in data_seq:
        let normalized = normalize_word(word)
        if normalized.len > 0 and not stop_words.contains(normalized):
            result.add(word)

    return result

when isMainModule:
    let data = FileOperations.read_file("../Data/test1.txt")
    let clean_text = remove_stopwords(tokenize(data))
    var corpus: seq[seq[string]] = @[clean_text]

    # echo count_frequency(clean_text)
    var tf = calculate_tf(clean_text)
    var idf = calculate_IDF(corpus)

    # for key, value in tf: 
    #     echo key

    # for word in clean_text:
    #     echo word
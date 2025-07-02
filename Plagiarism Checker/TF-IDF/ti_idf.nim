import std/[os, streams, strutils, sequtils, math, re, bitops, tables, sets]
import ../../Common/FileOperations

const stop_words = toHashSet([
  "a", "an", "this", "the", "is", "are", "was", "were", "will", "be",
  "in", "on", "at", "of", "for", "to", "from", "with",
  "and", "or", "but", "not", "if", "then", "else",
  "i", "you", "he", "she", "it", "we", "they", "my", "your", "his", "her",
  "its", "our", "their", "what", "who", "me", "as", "while", "that", 
  "shes", "hes", "theirs", "didnt", "couldnt", "wasnt", "dont", "werent", 
  "hadnt", "im", "youre", "whats", "youd", "yours", "thats", "shed", "ive", 
  "ill", "did", "oh", "now"
])

proc tokenize(data: string): seq[string] = 
  let cleaned = data
                .toLowerAscii()
                .replace(re"[-]{2,}", " ")  # remove '----' etc
  let tokenPattern = re"\b[\w'-]+\b"

  result = @[]
  for m in findAll(cleaned, tokenPattern):
    if m != "-" and m != "'":
      result.add(m)

proc normalize_word(word: string): string =
  word.toLowerAscii().strip(chars={'.', ',', '!', '?', ';', ':', '"', '\''})

proc remove_stopwords(data_seq: seq[string]): seq[string] = 
  for word in data_seq:
    let normalized = normalize_word(word)
    if normalized.len > 0 and not stop_words.contains(normalized):
      result.add(normalized)

proc calculate_tf(words: seq[string]): Table[string, float] = 
  var tf = initTable[string, float]()
  let total = words.len.float

  for word in words:
    tf.mgetOrPut(word, 0.0) += 1.0

  for key in tf.keys:
    tf[key] /= total

  result = tf

proc calculate_IDF(corpus: seq[seq[string]]): Table[string, float] = 
  var df = initTable[string, int]()
  let total_docs = corpus.len.float

  for document in corpus:
    let unique = toHashSet(document)
    for word in unique:
      df.mgetOrPut(word, 0) += 1

  result = initTable[string, float]()
  for word, count in df.pairs:
    result[word] = ln(total_docs / (1 + count.float))

proc calculate_TF_IDF(doc: seq[string], idf: Table[string, float]): Table[string, float] =
  let tf = calculate_tf(doc)
  result = initTable[string, float]()
  for word, tf_score in tf.pairs:
    result[word] = tf_score * idf.getOrDefault(word, ln(float(idf.len + 1)))

proc cosine_similarity(vec1, vec2: Table[string, float]): float =
  var dot, mag1, mag2: float

  for key, v1 in vec1:
    let v2 = vec2.getOrDefault(key, 0.0)
    dot += v1 * v2
    mag1 += v1 * v1

  for v in vec2.values:
    mag2 += v * v

  mag1 = sqrt(mag1)
  mag2 = sqrt(mag2)

  if mag1 == 0 or mag2 == 0: return 0.0
  result = dot / (mag1 * mag2)


when isMainModule:
    let input_data = FileOperations.read_file("../Data/Input-Data/input.txt")
    let data_one = FileOperations.read_file("../Data/test1.txt")
    let data_two = FileOperations.read_file("../Data/test2.txt")
    let data_three = FileOperations.read_file("../Data/test3.txt")
    let data_four = FileOperations.read_file("../Data/test4.txt")
    let data_five = FileOperations.read_file("../Data/test5.txt")


    let input_data_clean = remove_stopwords(tokenize(input_data))
    let data_one_clean = remove_stopwords(tokenize(data_one))
    let data_two_clean = remove_stopwords(tokenize(data_two))
    let data_three_clean = remove_stopwords(tokenize(data_three))
    let data_four_clean = remove_stopwords(tokenize(data_four))
    let data_five_clean = remove_stopwords(tokenize(data_five))

    var corpus: seq[seq[string]] = @[data_one_clean, data_two_clean, data_three_clean, data_four_clean, data_five_clean]
    let idf = calculate_IDF(corpus)

    let input_tf_idf = calculate_TF_IDF(input_data_clean, idf)

    for doc in corpus:
        let corpus_tf_idf = calculate_TF_IDF(doc, idf)
        let similarity = cosine_similarity(input_tf_idf, corpus_tf_idf)
        echo "Similarity Score: ", similarity * 100

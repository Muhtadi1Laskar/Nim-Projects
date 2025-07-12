import std/[tables, sequtils, math, random, strformat ]
import nimcrypto
import ../../Common/FileOperations

type
    Block = ref object
        index: int
        time_stamp: string
        data: string
        previous_hash: string
        validator: string
        hash: string

type
    Chain = ref object
        chain: seq[Block]
        validators: Table[string, int]

proc calculate_hash(block_data: Block): string = 
    let record: string = block_data.time_stamp & block_data.data & block_data.previous_hash & block_data.validator
    return toHex(sha512.digest(record).data)

proc create_genesis_block(): Block = 
    result = Block(
        index: 0,
        time_stamp: FileOperations.get_date_time(),
        data: "Genesis Block",
        previous_hash: "0",
        validator: "Network",
    )
    result.hash = calculate_hash(result)

proc add_validator(self: Chain, name: string, stake: int) = 
    self.validators[name] = stake

proc select_validator(self: Chain): string = 
    let 
        names: seq[string] = toSeq(self.validators.keys)
        stakes: seq[int] = toSeq(self.validators.values)
        total: float = sum(stakes).toFloat
    var probabilities: seq[float]

    if total == 0:
        return "Network"
    
    for i in stakes:
        probabilities.add(i.toFloat / total)
    
    result = sample(names, probabilities)

proc add_block(self: Chain, data: string): Block = 
    let validator: string = self.select_validator()
    let last_block: Block = self.chain[^1]
    var new_block: Block = Block(
        index: self.chain.len,
        time_stamp: FileOperations.get_date_time(),
        data: data,
        previous_hash: last_block.hash,
        validator: validator
    )
    new_block.hash = calculate_hash(new_block)

    self.chain.add(new_block)
    echo "✅ Block added by: ", validator
    return new_block


proc new_chain(): Chain =
    result = Chain(
        chain: @[create_genesis_block()], 
        validators: initTable[string, int]()
    )

proc `$`(b: Block): string =
  result = &"Block #{b.index} | Validator: {b.validator} | Hash: {b.hash[0..9]}..."

proc print_chain(self: Chain) = 
    for blocks in self.chain:
        echo  blocks

when isMainModule:
    randomize()

    let block_chain: Chain = new_chain()

    block_chain.add_validator("Alice", 50)
    block_chain.add_validator("Bob", 30)
    block_chain.add_validator("Saitama", 80)
    block_chain.add_validator("Charlie", 900)

    for i in 1..10:
        discard block_chain.add_block("Transaction #" & $i)

    echo "\n📦 Blockchain State:\n"

    block_chain.print_chain()
import std/[tables, sequtils, strutils, math, random]
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


proc create_genesis_block(): Block = 
    return Block(
        index: 0,
        time_stamp: FileOperations.get_date_time(),
        data: "Genesis Block",
        previous_hash: "0",
        validator: "None",
    )

proc calculate_hash(block_data: Block): string = 
    let record = $block_data.time_stamp & $block_data.data & $block_data.previous_hash & block_data.validator
    return toHex(sha512.digest(record).data)

proc add_validator(self: Chain, name: string, stake: int) = 
    self.validators[name] = stake

proc select_validator(self: Chain): string = 
    let 
        names: seq[string] = toSeq(self.validators.keys)
        stakes: seq[int] = toSeq(self.validators.values)
        total: float = sum(stakes).toFloat
    var probabilities: seq[float]
    
    for i in stakes:
        probabilities.add(i.toFloat / total)
    
    result = sample(names, probabilities)

proc add_block(self: Chain, data: string): Block = 
    let validator = self.select_validator()
    let last_block = self.chain[self.chain.len - 1]
    var new_block = Block(
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
    let genesis_block = create_genesis_block()
    genesis_block.hash = calculate_hash(genesis_block)

    result = Chain(
        chain: @[genesis_block], 
        validators: initTable[string, int]()
    )

proc `$`(b: Block): string =
  result = "Block(" &
           "index: " & $b.index & ", " &
           "data: " & $b.data & ", " &
           "time_stamp: " & b.time_stamp & ", " &
           "validator: " & b.validator & ", " &
           "hash: " & b.hash & ", " &
           "previous_hash: " & b.previous_hash & ")"

proc print_chain(self: Chain) = 
    for blocks in self.chain:
        echo  blocks

when isMainModule:
    let block_chain = new_chain()

    block_chain.add_validator("Alice", 50)
    block_chain.add_validator("Bob", 30)
    block_chain.add_validator("Charlie", 20)

    for i in 1..6:
        discard block_chain.add_block("Transcation ")

    echo "\n📦 Blockchain State:"

    block_chain.print_chain()
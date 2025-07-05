import std/[tables]
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

proc add_validator(self: Chain, name: string, stake: int) = 
    self.validators[name] = stake

proc calculate_hash(block_data: Block): string = 
    let record = $block_data.time_stamp & $block_data.data & $block_data.previous_hash & block_data.validator
    return toHex(sha512.digest(record).data)

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
           "time_stamp: " & b.time_stamp & ", " &
           "validator: " & b.validator & ", " &
           "hash: " & b.hash & ", " &
           "previous_hash: " & b.previous_hash & ")"

when isMainModule:
    let block_chain = new_chain()

    block_chain.add_validator("Alice", 50)
    block_chain.add_validator("Bob", 30)
    block_chain.add_validator("Charlie", 20)

    # for blocks in block_chain.chain:
    #     echo blocks

    echo block_chain.validators

    


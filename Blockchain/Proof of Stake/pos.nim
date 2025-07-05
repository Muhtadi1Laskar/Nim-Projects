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
        validators: Table[string, string]


proc create_genesis_block(): Block = 
    return Block(
        index: 0,
        time_stamp: FileOperations.get_date_time(),
        data: "Genesis Block",
        previous_hash: "0",
        validator: "None"
    )

proc calculate_hash(self: Chain, block_data: Block): string = 
    let record = $block_data.time_stamp & $block_data.data & $block_data.previous_hash & block_data.validator
    return toHex(sha512.digest(record).data)

proc new_chain(): Chain =
    result = Chain(
        chain: @[create_genesis_block()], 
        validators: initTable[string, string]()
    )

proc `$`(b: Block): string =
  result = "Block(" &
           "index: " & $b.index & ", " &
           "time_stamp: " & b.time_stamp & ", " &
           "validator: " & b.validator & ", " &
           "previous_hash: " & b.previous_hash & ")"

when isMainModule:
    let block_chain = new_chain()

    for blocks in block_chain.chain:
        let h = block_chain.calculate_hash(blocks)
        echo h

    


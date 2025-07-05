import std/[strutils, times, tables]
import nimcrypto
import ../Common/FileOperations

type
    Block = ref object
        index: int
        time_stamp: string
        proof: int
        previous_hash: string
    
type
    Chain = ref object
        chain: seq[Block]

proc create_block(self: Chain, proof: int, previous_hash: string): Block =
    let new_block = Block(
        index: self.chain.len + 1,
        time_stamp: FileOperations.get_date_time(),
        proof: proof,
        previous_hash: previous_hash
    )
    self.chain.add(new_block)

    return new_block

proc new_block_chain(): Chain = 
    let c = Chain(chain: @[])
    discard c.create_block(proof = 1, previousHash = "0")
    return c

proc `$`(self: Block): string =
  result = "Block(" &
           "index: " & $self.index & ", " &
           "time_stamp: " & self.time_stamp & ", " &
           "proof: " & $self.proof & ", " &
           "previous_hash: " & self.previous_hash & ")"


when isMainModule:
    let block_chain = new_block_chain()
    echo block_chain.chain
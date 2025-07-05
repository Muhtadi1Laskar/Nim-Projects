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

proc get_previous_block(self: Chain): Block = 
    return self.chain[self.chain.len-1]

proc hash_block(self: Chain, block_data: Block): string = 
    let record = $block_data.index & block_data.time_stamp & $block_data.proof & block_data.previous_hash
    let hash = toHex(sha512.digest(record).data)
    return hash

proc pow(self: Chain, prev_proof: int): int = 
    var new_proof = 1
    var check_proof = false

    while not check_proof:
        let num = (new_proof * new_proof) - (prev_proof * prev_proof)
        let hash_operation = toHex(sha512.digest($num).data)


        if hash_operation[0 ..< 4] == "000":
            check_proof = true
        else:
            new_proof += 1
    return new_proof

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
    let previous_block = block_chain.get_previous_block()
    let new_block = block_chain.create_block(23, previous_block.previous_hash)
    
    echo block_chain.chain
    echo block_chain.hash_block(new_block)
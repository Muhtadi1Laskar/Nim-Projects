import std/[tables]
import nimcrypto
import ../Common/FileOperations

type
    Block = ref object
        index: int
        time_stamp: string
        proof: int
        previous_hash: string

type 
    Response = ref object
        message: string
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
    var new_proof: int = 1
    var check_proof: bool = false

    while not check_proof:
        let num = (new_proof * new_proof) - (prev_proof * prev_proof)
        let hash_operation = toHex(sha512.digest($num).data)


        if hash_operation[0 ..< 4] == "0000":
            check_proof = true
        else:
            new_proof += 1
    return new_proof

proc mine_block(self: Chain): Response = 
    let previous_block = self.get_previous_block()
    let previous_proof = previous_block.proof
    let proof = self.pow(previous_proof)
    let previous_hash = self.hash_block(previous_block)
    let blocks = self.create_block(proof, previous_hash)
    
    return Response(
        message: "Congragulations you just mined a block",
        index: blocks.index,
        time_stamp: blocks.time_stamp,
        proof: blocks.proof,
        previous_hash: blocks.previous_hash
    )


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
    let chain = new_block_chain()

    for i in 0 ..< 20:
        let blocks = chain.mine_block()

        echo " "
        echo "Message: ", blocks.message
        echo "Index: ", blocks.index
        echo "Time Stamp: ", blocks.time_stamp
        echo "Proof: ", blocks.proof
        echo "Previous Hash: ", blocks.previous_hash
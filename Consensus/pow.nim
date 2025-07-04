import std/[strutils]
import nimcrypto

proc proof_of_work(message: string, difficulty: int): (int, string) = 
    var nonce = 0
    var prefix = '0'.repeat(difficulty)

    while true:
        let text = message & $nonce
        let block_hash = toHex(sha256.digest(text).data)

        if startsWith(block_hash, prefix):
            echo "Success with nonce: ", nonce
            echo "Hash: ", block_hash
            
            return (nonce, block_hash)

        nonce += 1


when isMainModule:
    let 
        block_data = "Block headar data here"
        difficulty = 4
    let (nonce, block_hash) = proof_of_work(block_data, difficulty)

    echo " "
    echo "Nonce: ", nonce
    echo "Block Data: ", block_hash
        

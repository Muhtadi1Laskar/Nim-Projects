import std/[strutils, times, tables]
import nimcrypto

type
    Block = ref object
        index: int
        time_stamp: string
        proof: int
        previous_hash: string


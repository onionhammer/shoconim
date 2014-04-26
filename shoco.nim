{.passl: "-L."}
{.compile: "shoco.c"}

# Import C functions
{.push importc.}
proc shoco_compress(inp: cstring, len: cint, outp: cstring, bufsize: cint): cint
    ## Compress the input buffer

proc shoco_decompress(inp: cstring, len: cint, outp: cstring, bufsize: cint): cint
    ## Decompress the input buffer
{.pop.}

# Nimrod wrapper
proc compress*(input: string): string =
    result = newStringOfCap(input.len)

    var length = shoco_compress(
        input, 0,
        result, input.len.cint
    )

    result.setLen(length)


proc decompress*(input: string): string =
    let buf_size = input.len * 4
    result = newStringOfCap(buf_size)

    var length = shoco_decompress(
        input, input.len.cint,
        result, buf_size.cint
    )

    result.setLen(length)

# Tests
when isMainModule:
    # Do tests
    var original   = "what's happening"

    # Compress original
    var compressed = compress(original)
    assert compressed != original
    assert compressed.len <= original.len

    # Decompress the compressed string
    var decompressed = decompress(compressed)
    assert decompressed == original
    assert decompressed.len == original.len
    echo "Tests passed"
import std/[math, complex]

proc Dft(signal: seq[float]): seq[Complex[float]] =
    let N = signal.len
    result = newSeq[Complex[float]](N)

    for k in 0..<N:
        var s = complex(0.0, 0.0)
        for n in 0..<N:
            let angle = -2.0 * PI * float(k * n) / float(N)
            let w = complex(cos(angle), sin(angle))
            s += signal[n] * w
        result[k] = s


when isMainModule:
    let samples = @[1.0, 0.0, -1.0, 0.0]
    let specturm = Dft(samples)

    echo specturm



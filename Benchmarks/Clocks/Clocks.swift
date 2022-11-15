import DateTime

import BenchmarkSupport
@main extension BenchmarkRunner {}

@_dynamicReplacement(for: registerBenchmarks)
func benchmarks() {

    Benchmark.defaultDesiredDuration = .seconds(2)
    Benchmark.defaultDesiredIterations = 1_000
    Benchmark.defaultThroughputScalingFactor = .kilo

    Benchmark("InternalUTCClock.now") { benchmark in
        for _ in 0 ..< benchmark.throughputScalingFactor.rawValue {
            BenchmarkSupport.blackHole(InternalUTCClock.now)
        }
    }

    Benchmark("Foundation.Date") { benchmark in
        for _ in 0 ..< benchmark.throughputScalingFactor.rawValue {
            BenchmarkSupport.blackHole(Foundation.Date())
        }
    }

}

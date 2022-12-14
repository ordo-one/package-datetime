// Copyright 2002 Ordo One AB
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

import DateTime

import BenchmarkSupport
@main extension BenchmarkRunner {}

@_dynamicReplacement(for: registerBenchmarks)
func benchmarks() {

    Benchmark.defaultDesiredDuration = .seconds(2)
    Benchmark.defaultDesiredIterations = 10_000
    Benchmark.defaultThroughputScalingFactor = .kilo

    Benchmark("InternalUTCClock.now") { benchmark in
        for _ in 0 ..< benchmark.throughputScalingFactor.rawValue {
            BenchmarkSupport.blackHole(InternalUTCClock.now)
        }
    }

    Benchmark("BenchmarkClock.now") { benchmark in
        for _ in 0 ..< benchmark.throughputScalingFactor.rawValue {
            BenchmarkSupport.blackHole(BenchmarkClock.now)
        }
    }

    Benchmark("Foundation.Date") { benchmark in
        for _ in 0 ..< benchmark.throughputScalingFactor.rawValue {
            BenchmarkSupport.blackHole(Foundation.Date())
        }
    }

}

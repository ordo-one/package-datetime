// Copyright 2002 Ordo One AB
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

@testable import DateTime
import XCTest

final class DateTimeTests: XCTestCase {
    func testExample() throws {
        let time = InternalUTCClock().measure {
            print("InternalUTCClock Time now: \(InternalUTCClock.now)")
            print("InternalUTCClock Time now: \(InternalUTCClock.now._value.components)")
            print("InternalUTCClock Resolution: \(InternalUTCClock().minimumResolution)")
        }
        print("InternalUTCClock Elapsed time in nanoseconds \(time.components.attoseconds / 1_000_000_000)")
        let time2 = InternalUTCClock().measure {
            _ = 47
        }
        print("""
        InternalUTCClock Elapsed time in nanoseconds for empty closure \
        \(time2.nanoseconds())
        """)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    func testBenchmarkClock() throws {
        let time = BenchmarkClock().measure {
            print("BenchmarkClock Time now: \(BenchmarkClock.now)")
            print("BenchmarkClock Time now: \(BenchmarkClock.now._value.components)")
            print("BenchmarkClock Resolution: \(BenchmarkClock().minimumResolution)")
        }
        print("BenchmarkClock Elapsed time in nanoseconds \(time.components.attoseconds / 1_000_000_000)")
        let time2 = BenchmarkClock().measure {
            _ = 47
        }
        print("""
        BenchmarkClock Elapsed time in nanoseconds for empty closure \
        \(time2.nanoseconds())
        """)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }

    func testFormatting() throws {
        func testFormat(attoseconds: Int64, expected: String) {
            let now = InternalUTCClock.now
            let dropCount = "2022-03-10 14:15:56.".count
            var description: String
            var instant: InternalUTCClock.Instant
            var fractionsOfSeconds: String.SubSequence

            instant = InternalUTCClock.Instant(secondsComponent: now.seconds(), attosecondsComponent: attoseconds)
            description = "\(instant)"
            fractionsOfSeconds = description.dropFirst(dropCount)
            XCTAssert(fractionsOfSeconds == expected, "Got \(fractionsOfSeconds) Expected \(expected)")

//            print("\(now)")
//            print("Got \(fractionsOfSeconds) Expected \(expected)")
        }

        testFormat(attoseconds: 12_345, expected: "000000")
        testFormat(attoseconds: 000_456_000_000_000_000, expected: "000456")
        testFormat(attoseconds: 123_456_000_000_000_000, expected: "123456")
        testFormat(attoseconds: 123_000_000_000_000_000, expected: "123000")
    }
}

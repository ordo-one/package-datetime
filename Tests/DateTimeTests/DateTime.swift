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
            print("Time now: \(InternalUTCClock.now)")
            print("Time now: \(InternalUTCClock.now._value.components)")
            print("Resolution: \(InternalUTCClock().minimumResolution)")
        }
        print("Elapsed time in nanoseconds \(time.components.attoseconds / 1_000_000_000)")
        let time2 = InternalUTCClock().measure {
            _ = 47
        }
        print("Elapsed time in nanoseconds for empty closure \(time2.components.attoseconds / 1_000_000_000)")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
    }
}

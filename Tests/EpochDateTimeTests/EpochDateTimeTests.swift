// Copyright 2023 Ordo One AB
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

@testable import DateTime
import XCTest

final class EpochDateTimeTests: XCTestCase {
    func test1672556400() throws {
        var epoch = EpochDateTime.unixEpoch()
        epoch.convert(timestamp: 1672556400)
        XCTAssertEqual(epoch.year, 2023)
        XCTAssertEqual(epoch.month, 1)
        XCTAssertEqual(epoch.day, 1)
    }
}

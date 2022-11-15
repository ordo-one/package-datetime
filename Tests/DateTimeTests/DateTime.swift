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

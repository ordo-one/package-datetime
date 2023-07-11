// Copyright 2023 Ordo One AB
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

@testable import DateTime
import XCTest

private let secondsPerHour = 60 * 60
private let secondsPerDay = 24 * 60 * 60
private let secondsPerMinute = 60
private let secondsPerNormalYear = 365 * secondsPerDay
private let secondsPerLeapYear = 366 * secondsPerDay

private let monthsNormal = [-9_999,
                            31 * secondsPerDay,
                            28 * secondsPerDay,
                            31 * secondsPerDay,
                            30 * secondsPerDay,
                            31 * secondsPerDay,
                            30 * secondsPerDay,
                            31 * secondsPerDay,
                            31 * secondsPerDay,
                            30 * secondsPerDay,
                            31 * secondsPerDay,
                            30 * secondsPerDay,
                            31 * secondsPerDay]

private let monthsLeap = [-9_999,
                          31 * secondsPerDay,
                          29 * secondsPerDay,
                          31 * secondsPerDay,
                          30 * secondsPerDay,
                          31 * secondsPerDay,
                          30 * secondsPerDay,
                          31 * secondsPerDay,
                          31 * secondsPerDay,
                          30 * secondsPerDay,
                          31 * secondsPerDay,
                          30 * secondsPerDay,
                          31 * secondsPerDay]

extension EpochDateTime {
    private func isLeapYear(_ year: Int) -> Bool {
        if (year % 4) != 0 {
            return false
        } else if (year % 100) != 0 {
            return true
        } else if (year % 400) != 0 {
            return false
        }
        return true
    }

    mutating func convertOld(timestamp: Int) {
        var remainingTime = timestamp

        while remainingTime > 0 {
            let isLeap = isLeapYear(year)

            if isLeap, remainingTime >= secondsPerLeapYear {
                remainingTime -= secondsPerLeapYear
                year += 1
            } else if !isLeap, remainingTime >= secondsPerNormalYear {
                remainingTime -= secondsPerNormalYear
                year += 1
            } else if isLeap, remainingTime >= monthsLeap[month] {
                remainingTime -= monthsLeap[month]
                month += 1
            } else if !isLeap, remainingTime >= monthsNormal[month] {
                remainingTime -= monthsNormal[month]
                month += 1
            } else if remainingTime >= secondsPerDay {
                remainingTime -= secondsPerDay
                day += 1
            } else if remainingTime >= secondsPerHour {
                remainingTime -= secondsPerHour
                hour += 1
            } else if remainingTime >= secondsPerMinute {
                remainingTime -= secondsPerMinute
                minute += 1
            } else {
                second = remainingTime
                remainingTime = 0
            }
        }
    }
}

final class EpochDateTimeTests: XCTestCase {

    func testPerf() throws {
        let clock = ContinuousClock()
        var vv: Int = 0

        let oldImplWorkTime = clock.measure {
            for time in 1672531200..<(1672531200+1_000_000) {
                var epoch = EpochDateTime.unixEpoch()
                epoch.convertOld(timestamp: time)
                vv += epoch.year
            }
        }

        print("Old implementation: vv=\(vv), elapsed time=\(oldImplWorkTime)")

        vv = 0
        let newImplWorkTime = clock.measure {
            for time in 1672531200..<(1672531200+1_000_000) {
                var epoch = EpochDateTime.unixEpoch()
                epoch.convert(timestamp: time)
                vv += epoch.year
            }
        }

        print("New implementation: vv=\(vv), elapsed time=\(newImplWorkTime)")
    }
}

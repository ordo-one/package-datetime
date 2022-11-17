// Copyright 2002 Ordo One AB
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

// An implementation of an UTC clock using Ordo:s internal datetime representation

// swiftlint:disable line_length identifier_name

// Largely adopted by Swift's ContinuousClock
// https://github.com/apple/swift/blob/48987de3d3ab228eed4867949795c188759df234/stdlib/public/Concurrency/ContinuousClock.swift#L49

#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#else
    #error("Unsupported Platform")
#endif

public struct InternalUTCClock {
    /// A continuous point in time used for `InternalUTCClock`.
    public struct Instant: Codable, Sendable {
        internal var _value: Swift.Duration

        internal init(_value: Swift.Duration) {
            self._value = _value
        }
        
        public func secondsSinceEpoch() -> Int64 {
            return self._value.components.seconds
        }
    }

    public init() {}
}

public extension Clock where Self == InternalUTCClock {
    /// A clock that measures time that always increments but does not stop
    /// incrementing while the system is asleep.
    ///
    ///       try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
    ///
    static var internalUTC: InternalUTCClock { return InternalUTCClock() }
}

extension InternalUTCClock: Clock {
    /// The current continuous instant.
    public var now: InternalUTCClock.Instant {
        InternalUTCClock.now
    }

    /// The minimum non-zero resolution between any two calls to `now`.
    public var minimumResolution: Swift.Duration {
        var resolution = timespec()

        let result = clock_getres(CLOCK_REALTIME, &resolution)

        guard result == 0 else {
            fatalError("Failed to get realtime clock resolution in clock_getres(), errno = \(errno)")
        }

        let seconds = Int64(resolution.tv_sec)
        let attoseconds = Int64(resolution.tv_nsec) * 1_000_000_000

        return Duration(secondsComponent: seconds, attosecondsComponent: attoseconds)
    }

    /// The current continuous instant.
    public static var now: InternalUTCClock.Instant {
        var currentTime = timespec()
        let result = clock_gettime(CLOCK_REALTIME, &currentTime)

        guard result == 0 else {
            fatalError("Failed to get current time in clock_gettime(), errno = \(errno)")
        }

        let seconds = Int64(currentTime.tv_sec)
        let attoseconds = Int64(currentTime.tv_nsec) * 1_000_000_000

        return InternalUTCClock.Instant(_value: Duration(secondsComponent: seconds, attosecondsComponent: attoseconds))
    }

    /// Suspend task execution until a given deadline within a tolerance.
    /// If no tolerance is specified then the system may adjust the deadline
    /// to coalesce CPU wake-ups to more efficiently process the wake-ups in
    /// a more power efficient manner.
    ///
    /// If the task is canceled before the time ends, this function throws
    /// `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    public func sleep(
        until deadline: Instant, tolerance: Swift.Duration? = nil
    ) async throws {
        try await Task.sleep(until: deadline, tolerance: tolerance, clock: .internalUTC)
    }
}

extension InternalUTCClock.Instant: InstantProtocol {
    public static var now: InternalUTCClock.Instant { InternalUTCClock.now }

    public func advanced(by duration: Swift.Duration) -> InternalUTCClock.Instant {
        return InternalUTCClock.Instant(_value: _value + duration)
    }

    public func duration(to other: InternalUTCClock.Instant) -> Swift.Duration {
        other._value - _value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(_value)
    }

    public static func == (
        _ lhs: InternalUTCClock.Instant, _ rhs: InternalUTCClock.Instant
    ) -> Bool {
        return lhs._value == rhs._value
    }

    public static func < (
        _ lhs: InternalUTCClock.Instant, _ rhs: InternalUTCClock.Instant
    ) -> Bool {
        return lhs._value < rhs._value
    }

    @inlinable
    public static func + (
        _ lhs: InternalUTCClock.Instant, _ rhs: Swift.Duration
    ) -> InternalUTCClock.Instant {
        lhs.advanced(by: rhs)
    }

    @inlinable
    public static func += (
        _ lhs: inout InternalUTCClock.Instant, _ rhs: Swift.Duration
    ) {
        lhs = lhs.advanced(by: rhs)
    }

    @inlinable
    public static func - (
        _ lhs: InternalUTCClock.Instant, _ rhs: Swift.Duration
    ) -> InternalUTCClock.Instant {
        lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func -= (
        _ lhs: inout InternalUTCClock.Instant, _ rhs: Swift.Duration
    ) {
        lhs = lhs.advanced(by: .zero - rhs)
    }

    @inlinable
    public static func - (
        _ lhs: InternalUTCClock.Instant, _ rhs: InternalUTCClock.Instant
    ) -> Swift.Duration {
        rhs.duration(to: lhs)
    }
}

public extension Duration {
    func nanoseconds() -> Int64 {
        (components.seconds * 1_000_000_000) + (components.attoseconds / 1_000_000_000)
    }
}

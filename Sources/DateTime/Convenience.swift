public extension Duration {
    func nanoseconds() -> Int64 {
        return (self.components.seconds * 1_000_000_000) + (self.components.attoseconds / 1_000_000_000)
    }
}

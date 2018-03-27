public func OpenWhiskAction(main: ([String: Any]) -> [String: Any]) -> Void {
  return _run_main(mainFunction: main) 
}

public func OpenWhiskAction<In: Codable, Out: Codable>(main: (In, (Out?, Error?) -> Void) -> Void) {
    return _run_main(mainFunction: main)
}

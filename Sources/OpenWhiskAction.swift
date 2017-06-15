public func OpenWhiskAction(main: ([String: Any]) -> [String: Any]) -> Void {
  return _run_main(mainFunction: main) 
}

public extension NSURLQueryItem {
  static func initAndEncode(key: String, value: String) -> NSURLQueryItem? {
    guard let encodedKey = encode(key),
          let encodedValue = encode(value)
      else { return .None }

    return NSURLQueryItem(name: encodedKey, value: encodedValue)
  }

  static func decode(data: NSData?) -> [NSURLQueryItem] {
    guard let data = data else { return [] }
    let result = String(data: data, encoding: NSUTF8StringEncoding)
      .flatMap { $0.componentsSeparatedByString("&") }?
      .map { $0.componentsSeparatedByString("=") }
      .reduce([], combine: stringToQueryItem)

    return result ?? []
  }

  private static func stringToQueryItem(accum: [NSURLQueryItem]?, el: [String]) -> [NSURLQueryItem]? {
    guard let key = el[safe: 0]?.stringByRemovingPercentEncoding,
          let value = el[safe: 1]?.stringByRemovingPercentEncoding
          else { return accum }
    return accum.flatMap { $0 + [NSURLQueryItem(name: key, value: value)] }
  }

  private static func encode(s: String) -> String? {
    let characterSet = NSMutableCharacterSet()
    let disallowed = NSCharacterSet.URLQueryAllowedCharacterSet()
    characterSet.formUnionWithCharacterSet(disallowed.invertedSet)
    characterSet.addCharactersInString("&=")

    return s.stringByAddingPercentEncodingWithAllowedCharacters(characterSet.invertedSet)
  }
}

private extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : .None
  }
}

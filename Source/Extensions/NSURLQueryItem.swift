@available(macOSApplicationExtension 10.10, *)
public extension URLQueryItem {
  static func encode(key: String, value: String) -> URLQueryItem? {
    guard let encodedKey = encode(key),
          let encodedValue = encode(value)
      else { return .none }

    return URLQueryItem(name: encodedKey, value: encodedValue)
  }

  static func decode(_ data: Data?) -> [URLQueryItem] {
    guard let data = data else { return [] }
    let result = String(data: data, encoding: .utf8)
      .flatMap { $0.components(separatedBy: "&") }?
      .map { $0.components(separatedBy: "=") }
      .reduce([], stringToQueryItem)

    return result ?? []
  }

  private static func stringToQueryItem(accum: [URLQueryItem]?, el: [String]) -> [URLQueryItem]? {
    guard let key = el[safe: 0]?.removingPercentEncoding,
          let value = el[safe: 1]?.removingPercentEncoding
          else { return accum }
    return accum.flatMap { $0 + [URLQueryItem(name: key, value: value)] }
  }

  private static func encode(_ s: String) -> String? {
    let disallowed = CharacterSet.urlQueryAllowed
    var characterSet = CharacterSet()
    characterSet.formUnion(disallowed.inverted)
    characterSet.insert(charactersIn: "&=")
    return s.addingPercentEncoding(withAllowedCharacters: characterSet.inverted)
  }
}

private extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : .none
  }
}

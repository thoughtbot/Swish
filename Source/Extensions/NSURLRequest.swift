import Foundation

public extension URLRequest {
  var jsonPayload: Any {
    get {
      return httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0) } ?? [:]
    }
    set {
      httpBody = try? JSONSerialization.data(withJSONObject: newValue)
    }
  }

  @available(macOSApplicationExtension 10.10, *)
  var formStylePayload: [String: String]? {
    get {
      return URLQueryItem.decode(httpBody)
        .reduce([:], queryItemToDictionary)
    }

    set {
      if let parameters = newValue {
        let queryString = parameters
          .map { URLQueryItem.encode(key: $0.0, value: $0.1) }
          .flatMap { $0 }
          .queryString

        httpBody = queryString.data(using: .utf8)
      }
    }
  }

  @available(macOSApplicationExtension 10.10, *)
  private func queryItemToDictionary( accum: [String: String]?, el: URLQueryItem) -> [String: String]? {
    guard let value = el.value else { return accum }
    var accum = accum
    accum?[el.name] = value
    return accum
  }
}

@available(macOSApplicationExtension 10.10, *)
private extension Collection where Iterator.Element == URLQueryItem {
  var queryString: String {
    return sorted { $0.name < $1.name }
      .reduce([]) { accum, el in
        guard let v = el.value else { return accum }
        return accum + ["\(el.name)=\(v)"]
      }
      .joined(separator: "&")
  }
}

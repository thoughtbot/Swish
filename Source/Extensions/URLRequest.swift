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
  var formURLEncodedPayload: [URLQueryItem] {
    get {
      var components = URLComponents()
      components.query = httpBody.flatMap { String(data: $0, encoding: .utf8) }
      return components.queryItems ?? []
    }

    set {
      var components = URLComponents()
      components.queryItems = newValue
      httpBody = components.query!.data(using: .utf8)
    }
  }
}

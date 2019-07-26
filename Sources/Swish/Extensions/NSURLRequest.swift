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
}

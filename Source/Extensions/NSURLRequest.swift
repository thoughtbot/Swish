import Foundation

public extension URLRequest {
  var jsonPayload: AnyObject {
    get {
      let json = httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: JSONSerialization.ReadingOptions(rawValue: 0)) }
      if let jsonDict = json as? [String: AnyObject] {
        return jsonDict
      }

      let jsonArray = json as? [AnyObject]
      return jsonArray ?? [:]
    }

    set {
      httpBody = try? JSONSerialization.data(withJSONObject: newValue, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
  }
}

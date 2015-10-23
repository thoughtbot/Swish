import Foundation

public extension NSURLRequest {
  var jsonPayload: NSDictionary {
    let json = HTTPBody.flatMap { try? NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions(rawValue: 0)) }
    return (json as? [String: AnyObject]) ?? [:]
  }
}

public extension NSMutableURLRequest {
  override var jsonPayload: NSDictionary {
    get {
      return super.jsonPayload
    }

    set {
      HTTPBody = try? NSJSONSerialization.dataWithJSONObject(newValue, options: NSJSONWritingOptions(rawValue: 0))
    }
  }
}

import Foundation

public extension NSURLRequest {
  var jsonPayload: AnyObject {
    let json = HTTPBody.flatMap { try? NSJSONSerialization.JSONObjectWithData($0, options: NSJSONReadingOptions(rawValue: 0)) }
    if let jsonDict = json as? [String: AnyObject] {
      return jsonDict
    }

    let jsonArray = json as? [AnyObject]
    return jsonArray ?? [:]
  }
}

public extension NSMutableURLRequest {
  override var jsonPayload: AnyObject {
    get {
      return super.jsonPayload
    }

    set {
      HTTPBody = try? NSJSONSerialization.dataWithJSONObject(newValue, options: NSJSONWritingOptions(rawValue: 0))
    }
  }
}

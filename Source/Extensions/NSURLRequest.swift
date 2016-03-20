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

  var formStylePayload: [String: String]? {
    return NSURLQueryItem.decode(HTTPBody)
      .reduce([:], combine: queryItemToDictionary)
  }

  private func queryItemToDictionary(var accum: [String: String]?, el: NSURLQueryItem) -> [String: String]? {
    guard let value = el.value else { return accum }
    accum?[el.name] = value

    return accum
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

  override var formStylePayload: [String: String]? {
    get {
      return super.formStylePayload
    }

    set {
      if let parameters = newValue {
        let queryString = parameters
          .map { NSURLQueryItem.initAndEncode($0.0, value: $0.1) }
          .flatMap { $0 }
          .queryString

        HTTPBody = queryString.dataUsingEncoding(NSUTF8StringEncoding)
      }
    }
  }
}

private extension CollectionType where Generator.Element == NSURLQueryItem {
  var queryString: String {
    return sort { $0.name < $1.name }
    .reduce([]) { accum, el in
      guard let v = el.value else { return accum }
      return accum + ["\(el.name)=\(v)"]
    }
    .joinWithSeparator("&")
  }
}
